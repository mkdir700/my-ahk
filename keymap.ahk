#Requires AutoHotkey v2.0

; ============================================================================
; AutoHotkey 键盘映射工具 / AutoHotkey Keyboard Mapping Tool
; ============================================================================

; ============================================================================
; 全局配置 / Global Configuration
; ============================================================================
class Config {
    static DEBUG := false  ; 调试模式 / Debug mode
}

; ============================================================================
; ESC + HJKL 导航模块 / ESC + HJKL Navigation Module
; ============================================================================
class EscNavigation {
    ; 静态属性 / Static properties
    static escPressed := false
    static escUsedInCombo := false
    static escPressTime := 0
    static MAX_SOLO_PRESS_TIME := 300  ; 最大单独按键时间(毫秒) / Max solo press time (ms)
    
    ; 初始化模块 / Initialize module
    static Init() {
        this.RegisterHotkeys()
        if (Config.DEBUG) {
            OutputDebug("EscNavigation module initialized")
        }
    }
    
    ; 注册热键 / Register hotkeys
    static RegisterHotkeys() {
        ; ESC 键处理 / ESC key handling
        Hotkey("Esc", (*) => this.OnEscDown())
        Hotkey("Esc Up", (*) => this.OnEscUp())
        
        ; HJKL 键处理 / HJKL key handling
        Hotkey("$h", (*) => this.OnH())
        Hotkey("$j", (*) => this.OnJ())
        Hotkey("$k", (*) => this.OnK())
        Hotkey("$l", (*) => this.OnL())
    }
    
    ; ESC 键按下处理 / ESC key down handler
    static OnEscDown() {
        this.escPressed := true
        this.escUsedInCombo := false
        this.escPressTime := A_TickCount
        if (Config.DEBUG) {
            OutputDebug("ESC pressed at " . this.escPressTime . " - Navigation mode ON")
        }
    }
    
    ; ESC 键释放处理 / ESC key up handler
    static OnEscUp() {
        if (this.escPressed && !this.escUsedInCombo) {
            ; 检查是否为单独按键 / Check if it's a solo press
            pressDuration := A_TickCount - this.escPressTime
            if (pressDuration <= this.MAX_SOLO_PRESS_TIME) {
                ; 发送 ESC 键 / Send ESC key
                Send("{Escape}")
                if (Config.DEBUG) {
                    OutputDebug("Solo ESC press -> Escape (duration: " . pressDuration . "ms)")
                }
            } else {
                if (Config.DEBUG) {
                    OutputDebug("ESC press too long (" . pressDuration . "ms), ignored")
                }
            }
        }
        
        this.escPressed := false
        this.escUsedInCombo := false
        if (Config.DEBUG) {
            OutputDebug("ESC released - Navigation mode OFF")
        }
    }
    
    ; H 键处理 / H key handler
    static OnH() {
        if (this.escPressed) {
            this.escUsedInCombo := true  ; 标记 ESC 被用于组合键 / Mark ESC as used in combo
            Send("{Left}")  ; h -> 左箭头 / Left arrow
            if (Config.DEBUG) {
                OutputDebug("ESC+H -> Left arrow")
            }
        } else {
            Send("h")  ; 正常发送 h / Send h normally
        }
    }
    
    ; J 键处理 / J key handler
    static OnJ() {
        if (this.escPressed) {
            this.escUsedInCombo := true  ; 标记 ESC 被用于组合键 / Mark ESC as used in combo
            Send("{Down}")  ; j -> 下箭头 / Down arrow
            if (Config.DEBUG) {
                OutputDebug("ESC+J -> Down arrow")
            }
        } else {
            Send("j")  ; 正常发送 j / Send j normally
        }
    }
    
    ; K 键处理 / K key handler
    static OnK() {
        if (this.escPressed) {
            this.escUsedInCombo := true  ; 标记 ESC 被用于组合键 / Mark ESC as used in combo
            Send("{Up}")  ; k -> 上箭头 / Up arrow
            if (Config.DEBUG) {
                OutputDebug("ESC+K -> Up arrow")
            }
        } else {
            Send("k")  ; 正常发送 k / Send k normally
        }
    }
    
    ; L 键处理 / L key handler
    static OnL() {
        if (this.escPressed) {
            this.escUsedInCombo := true  ; 标记 ESC 被用于组合键 / Mark ESC as used in combo
            Send("{Right}")  ; l -> 右箭头 / Right arrow
            if (Config.DEBUG) {
                OutputDebug("ESC+L -> Right arrow")
            }
        } else {
            Send("l")  ; 正常发送 l / Send l normally
        }
    }
    
    ; 启用模块 / Enable module
    static Enable() {
        this.RegisterHotkeys()
        if (Config.DEBUG) {
            OutputDebug("EscNavigation module enabled")
        }
    }
    
    ; 禁用模块 / Disable module
    static Disable() {
        try {
            Hotkey("Esc", "Off")
            Hotkey("Esc Up", "Off")
            Hotkey("$h", "Off")
            Hotkey("$j", "Off")
            Hotkey("$k", "Off")
            Hotkey("$l", "Off")
        }
        if (Config.DEBUG) {
            OutputDebug("EscNavigation module disabled")
        }
    }
}

; ============================================================================
; 双击顿号替换模块 / Double Comma Replacement Module
; ============================================================================
class DoubleCommaReplace {
    ; 静态属性 / Static properties
    static lastCommaTime := 0
    static DOUBLE_PRESS_INTERVAL := 500  ; 双击间隔时间(毫秒) / Double press interval (ms)

    ; 初始化模块 / Initialize module
    static Init() {
        ; 暂时禁用此模块以避免输入问题 / Temporarily disable this module to avoid input issues
        if (Config.DEBUG) {
            OutputDebug("DoubleCommaReplace module initialized (disabled)")
        }
    }

    ; 启用模块 / Enable module
    static Enable() {
        if (Config.DEBUG) {
            OutputDebug("DoubleCommaReplace module enabled (disabled)")
        }
    }

    ; 禁用模块 / Disable module
    static Disable() {
        if (Config.DEBUG) {
            OutputDebug("DoubleCommaReplace module disabled")
        }
    }
}

; ============================================================================
; Control -> Shift 映射模块 / Control to Shift Mapping Module
; ============================================================================
class ControlToShift {
    ; 静态属性 / Static properties
    static ctrlPressed := false
    static ctrlUsedInCombo := false
    static ctrlPressTime := 0
    static MAX_SOLO_PRESS_TIME := 300  ; 最大单独按键时间(毫秒) / Max solo press time (ms)
    
    ; 初始化模块 / Initialize module
    static Init() {
        this.RegisterHotkeys()
        if (Config.DEBUG) {
            OutputDebug("ControlToShift module initialized")
        }
    }
    
    ; 注册热键 / Register hotkeys
    static RegisterHotkeys() {
        ; Control 键处理 / Control key handling
        Hotkey("~LControl", (*) => this.OnCtrlDown())
        Hotkey("~LControl Up", (*) => this.OnCtrlUp())
        Hotkey("~RControl", (*) => this.OnCtrlDown())
        Hotkey("~RControl Up", (*) => this.OnCtrlUp())
        
        ; 监听所有可能的 Ctrl 组合键 / Monitor all possible Ctrl combinations
        this.RegisterCtrlCombos()
    }
    
    ; 注册 Ctrl 组合键监听 / Register Ctrl combination monitoring
    static RegisterCtrlCombos() {
        ; 常用的 Ctrl 组合键 / Common Ctrl combinations
        combos := ["a", "c", "v", "x", "z", "y", "s", "o", "n", "w", "t", "r", "f", "h", "p", "q", "e", "d", "b", "i", "u", "k", "l", "m", "g", "j"]
        
        for combo in combos {
            try {
                Hotkey("~^" . combo, (*) => this.OnCtrlCombo())
            }
        }
        
        ; 功能键组合 / Function key combinations
        Loop 12 {
            try {
                Hotkey("~^F" . A_Index, (*) => this.OnCtrlCombo())
            }
        }
        
        ; 数字键组合 / Number key combinations
        Loop 10 {
            i := A_Index - 1  ; 0-9
            try {
                Hotkey("~^" . i, (*) => this.OnCtrlCombo())
            }
        }
        
        ; 特殊键组合 / Special key combinations
        specialKeys := ["Tab", "Enter", "Space", "Backspace", "Delete", "Home", "End", "PgUp", "PgDn", "Left", "Right", "Up", "Down"]
        for key in specialKeys {
            try {
                Hotkey("~^" . key, (*) => this.OnCtrlCombo())
            }
        }
    }
    
    ; Control 键按下处理 / Control key down handler
    static OnCtrlDown() {
        this.ctrlPressed := true
        this.ctrlUsedInCombo := false
        this.ctrlPressTime := A_TickCount
        if (Config.DEBUG) {
            OutputDebug("Control pressed at " . this.ctrlPressTime)
        }
    }
    
    ; Control 键释放处理 / Control key up handler
    static OnCtrlUp() {
        if (this.ctrlPressed && !this.ctrlUsedInCombo) {
            ; 检查是否为单独按键 / Check if it's a solo press
            pressDuration := A_TickCount - this.ctrlPressTime
            if (pressDuration <= this.MAX_SOLO_PRESS_TIME) {
                ; 发送 Shift 键 / Send Shift key
                Send("{Shift}")
                if (Config.DEBUG) {
                    OutputDebug("Solo Control press -> Shift (duration: " . pressDuration . "ms)")
                }
            } else {
                if (Config.DEBUG) {
                    OutputDebug("Control press too long (" . pressDuration . "ms), ignored")
                }
            }
        }
        
        this.ctrlPressed := false
        this.ctrlUsedInCombo := false
    }
    
    ; Ctrl 组合键处理 / Ctrl combination handler
    static OnCtrlCombo() {
        this.ctrlUsedInCombo := true
        if (Config.DEBUG) {
            OutputDebug("Control used in combination - solo mapping disabled")
        }
    }
    
    ; 启用模块 / Enable module
    static Enable() {
        this.RegisterHotkeys()
        if (Config.DEBUG) {
            OutputDebug("ControlToShift module enabled")
        }
    }
    
    ; 禁用模块 / Disable module
    static Disable() {
        try {
            Hotkey("~LControl", "Off")
            Hotkey("~LControl Up", "Off")
            Hotkey("~RControl", "Off")
            Hotkey("~RControl Up", "Off")
            ; 注意：组合键热键会在应用重启时自动清理
            ; Note: Combination hotkeys will be automatically cleaned up on app restart
        }
        if (Config.DEBUG) {
            OutputDebug("ControlToShift module disabled")
        }
    }
}

; ============================================================================
; 主应用程序类 / Main Application Class
; ============================================================================
class KeymapApp {
    ; 应用程序版本 / Application version
    static VERSION := "1.1.0"
    
    ; 初始化应用程序 / Initialize application
    static Init() {
        ; 显示启动信息 / Show startup info
        if (Config.DEBUG) {
            OutputDebug("KeymapApp v" . this.VERSION . " starting...")
        }
        
        ; 初始化各个模块 / Initialize modules
        EscNavigation.Init()
        ControlToShift.Init()
        DoubleCommaReplace.Init()
        
        ; 显示就绪信息 / Show ready info
        if (Config.DEBUG) {
            OutputDebug("KeymapApp ready!")
        }
    }
    
    ; 退出应用程序 / Exit application
    static Exit() {
        if (Config.DEBUG) {
            OutputDebug("KeymapApp exiting...")
        }
        ExitApp()
    }
    
    ; 重新加载应用程序 / Reload application
    static Reload() {
        if (Config.DEBUG) {
            OutputDebug("KeymapApp reloading...")
        }
        Reload()
    }
}

; ============================================================================
; 应用程序启动 / Application Startup
; ============================================================================
KeymapApp.Init()

; ============================================================================
; 系统热键 / System Hotkeys
; ============================================================================
; Ctrl+Alt+R: 重新加载脚本 / Reload script
^!r::KeymapApp.Reload()

; Ctrl+Alt+Q: 退出脚本 / Exit script
^!q::KeymapApp.Exit()

; ============================================================================
; Alt+Space 与 Win+Space 交换 / Swap Alt+Space and Win+Space
; ============================================================================
!Space::Send("#{Space}")   ; Alt+Space 发送 Win+Space
#Space::Send("!{Space}")   ; Win+Space 发送 Alt+Space

; ============================================================================
; Win+` 映射到 Alt+` / Map Win+` to Alt+`
; ============================================================================
#`::Send("!{``}")          ; Win+` 发送 Alt+`