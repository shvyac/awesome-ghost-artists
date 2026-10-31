//! Simple calculator core for iOS (C FFI).
use std::ffi::{c_char, CString};

#[derive(Clone, Copy, PartialEq, Debug)]
enum Op { Add, Sub, Mul, Div }

impl Op {
    fn apply(self, a: f64, b: f64) -> Option<f64> {
        let r = match self {
            Op::Add => a + b,
            Op::Sub => a - b,
            Op::Mul => a * b,
            Op::Div => if b == 0.0 { return None } else { a / b },
        };
        r.is_finite().then_some(r)
    }
}

pub struct Calculator {
    display: String,
    acc: Option<f64>,
    op: Option<Op>,
    fresh: bool, // 次の数字入力で表示を置き換える
    error: bool,
}

impl Default for Calculator {
    fn default() -> Self { Self::new() }
}

impl Calculator {
    pub fn new() -> Self {
        Self { display: "0".into(), acc: None, op: None, fresh: true, error: false }
    }

    pub fn display(&self) -> &str {
        if self.error { "Error" } else { &self.display }
    }

    fn value(&self) -> f64 { self.display.parse().unwrap_or(0.0) }

    fn set_value(&mut self, v: f64) { self.display = format_number(v); }

    /// キー: 0-9 . + - * / = C(クリア) N(符号反転) %(パーセント)
    pub fn press(&mut self, key: char) {
        if self.error && key != 'C' { return; }
        match key {
            '0'..='9' => {
                if self.fresh || self.display == "0" {
                    self.display = key.to_string();
                } else if self.display.len() < 15 {
                    self.display.push(key);
                }
                self.fresh = false;
            }
            '.' => {
                if self.fresh { self.display = "0.".into(); self.fresh = false; }
                else if !self.display.contains('.') { self.display.push('.'); }
            }
            '+' | '-' | '*' | '/' => {
                if !self.fresh { self.compute(); }
                if self.error { return; }
                self.acc = Some(self.value());
                self.op = Some(match key { '+' => Op::Add, '-' => Op::Sub, '*' => Op::Mul, _ => Op::Div });
                self.fresh = true;
            }
            '=' => { self.compute(); self.op = None; self.acc = None; self.fresh = true; }
            'N' => { let v = -self.value(); self.set_value(v); }
            '%' => { let v = self.value() / 100.0; self.set_value(v); }
            'C' => *self = Self::new(),
            _ => {}
        }
    }

    fn compute(&mut self) {
        if let (Some(a), Some(op)) = (self.acc, self.op) {
            match op.apply(a, self.value()) {
                Some(r) => { self.set_value(r); self.acc = Some(r); }
                None => self.error = true,
            }
        }
    }
}

fn format_number(v: f64) -> String {
    if v == 0.0 { return "0".into(); }
    if v.abs() >= 1e15 || v.abs() < 1e-9 { return format!("{:e}", v); }
    let s = format!("{:.10}", v);
    s.trim_end_matches('0').trim_end_matches('.').to_string()
}

// ---------- C FFI (Swift から呼ぶ) ----------

#[no_mangle]
pub extern "C" fn calc_new() -> *mut Calculator {
    Box::into_raw(Box::new(Calculator::new()))
}

/// # Safety
/// `ptr` は calc_new が返したもの
#[no_mangle]
pub unsafe extern "C" fn calc_free(ptr: *mut Calculator) {
    if !ptr.is_null() { drop(Box::from_raw(ptr)); }
}

/// # Safety
/// `ptr` は calc_new が返した有効なポインタ
#[no_mangle]
pub unsafe extern "C" fn calc_press(ptr: *mut Calculator, key: u32) {
    if let (Some(c), Some(k)) = (ptr.as_mut(), char::from_u32(key)) { c.press(k); }
}

/// 戻り値は calc_string_free で解放すること
/// # Safety
/// `ptr` は calc_new が返した有効なポインタ
#[no_mangle]
pub unsafe extern "C" fn calc_display(ptr: *const Calculator) -> *mut c_char {
    let s = ptr.as_ref().map(|c| c.display()).unwrap_or("");
    CString::new(s).unwrap_or_default().into_raw()
}

/// # Safety
/// `s` は calc_display が返したもの
#[no_mangle]
pub unsafe extern "C" fn calc_string_free(s: *mut c_char) {
    if !s.is_null() { drop(CString::from_raw(s)); }
}

#[cfg(test)]
mod tests {
    use super::*;
    fn run(keys: &str) -> String {
        let mut c = Calculator::new();
        keys.chars().for_each(|k| c.press(k));
        c.display().to_string()
    }
    #[test] fn add() { assert_eq!(run("12+3="), "15"); }
    #[test] fn chain() { assert_eq!(run("2+3*4="), "20"); } // 電卓式（左から順に計算）
    #[test] fn decimal() { assert_eq!(run("0.1+0.2="), "0.3"); }
    #[test] fn divide() { assert_eq!(run("10/4="), "2.5"); }
    #[test] fn div_zero() { assert_eq!(run("5/0="), "Error"); assert_eq!(run("5/0=C"), "0"); }
    #[test] fn negate_percent() { assert_eq!(run("5N"), "-5"); assert_eq!(run("50%"), "0.5"); }
    #[test] fn ffi() {
        unsafe {
            let p = calc_new();
            for k in "7*6=".chars() { calc_press(p, k as u32); }
            let s = calc_display(p);
            assert_eq!(std::ffi::CStr::from_ptr(s).to_str().unwrap(), "42");
            calc_string_free(s); calc_free(p);
        }
    }
}
