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
; ============ 公共设置 ============
; 避免 Alt 触发菜单栏等副作用
A_MenuMaskKey := "vkE8"
; 指令部分：
; #WinActivateForce 是一项全局指令，强制窗口激活函数使用更激进的方法。
; 这有助于解决在快速连续激活窗口时可能出现的任务栏按钮闪烁问题。
; 请注意，此指令会影响脚本中所有 WinActivate 函数的行为。
#WinActivateForce


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

; RAlt 单独按：按住期间发送 Win+Ctrl+Shift+Alt
RAlt:: {
    Send "{LWin down}{Ctrl down}{Shift down}{Alt down}"
    KeyWait "RAlt"   ; 等待 RAlt 松开（v2 调用方式）
    Send "{LWin up}{Ctrl up}{Shift up}{Alt up}"
}

; 通用函数部分：
; 将核心逻辑封装在函数中，以便重用。
; -------------------------------------------------------------------------
; 函数名: OpenOrFocus
; 描述:   检查特定应用程序的窗口是否存在，若存在则激活，否则启动。
; 参数:
;   - WinIdentifier: 窗口匹配的标准，推荐使用 "ahk_exe" 或 "ahk_class"。
;   - RunPath:       应用程序的完整可执行文件路径。
; -------------------------------------------------------------------------
OpenOrFocus(WinIdentifier, RunPath)
{
    ; 检查是否存在符合 WinIdentifier 的窗口。
    ; WinExist() 返回一个非零的窗口句柄（HWND）如果找到，否则返回0。
    ; 任何非零值在条件判断中都被视为 true。
    if WinExist(WinIdentifier)
    {
        ; WinExist 成功找到窗口后，AHK 会自动将其设置为“最后找到的窗口”。
        ; 无参数的 WinActivate 将作用于这个窗口，避免了重复搜索，从而提高效率。
        ; 如果窗口已最小化，WinActivate 会自动将其恢复。
        WinActivate
    }
    else
    {
        ; 如果没有找到匹配的窗口，则执行 Run 命令来启动应用程序。
        Run RunPath
    }
}

; ========== Super 键映射 (RAlt) ==========
; --- Super 前缀：按住 RAlt 时，以下键生效（AHK v2） ---
#HotIf GetKeyState("RAlt", "P")
c:: Run "& 'C:\Program Files\Google\Chrome\Application\chrome.exe'"
v:: Run "C:\\Users\\wuy6\\AppData\\Local\\Programs\\Microsoft VS Code\\bin\\code.exe;"      ; Super + v
e:: Run "msedge"    ; Super + e
t:: Run "teams"     ; Super + t
o:: Run "outlook"   ; Super + o
#HotIf

; KeepAwake_v2.ahk — AutoHotkey v2
; 托盘菜单 + 保持屏幕常亮 + 维持 Teams 在线（轻量输入脉冲）
#Requires AutoHotkey v2.0

; ========= 常量 =========
ES_DISPLAY_REQUIRED  := 0x00000002
ES_SYSTEM_REQUIRED   := 0x00000001
ES_CONTINUOUS        := 0x80000000

DEFAULT_INTERVAL_MS := 30000  ; 默认 30 秒
RANDOM_JITTER_MS    := 4000   ; 随机抖动 ±4 秒

; ========= 全局状态 =========
global state := Map(
  "keepDisplayOn", false,
  "keepOnline",    false,
  "intervalMs",    DEFAULT_INTERVAL_MS,
  "randomize",     true
)

; “间隔”子菜单选项（键=菜单文本，值=毫秒）
global intervals := Map(
  "15 秒", 15000,
  "30 秒", 30000,
  "60 秒", 60000
)

; ========= 托盘菜单 =========
A_IconTip := "KeepAwake (AHK v2)"
A_TrayMenu.Delete()  ; 清空默认项

global intervalMenu := Menu()
for label, ms in intervals {
  intervalMenu.Add(label, SetIntervalMs.Bind(ms))
}
intervalMenu.Add("自定义…", CustomInterval)

A_TrayMenu.Add("保持常亮（显示/系统）", ToggleKeepDisplayOn)
A_TrayMenu.Add("保持在线（轻量输入脉冲）", ToggleKeepOnline)
A_TrayMenu.Add() ; 分隔
A_TrayMenu.Add("间隔", intervalMenu)
A_TrayMenu.Add("随机化间隔", ToggleRandomize)
A_TrayMenu.Add() ; 分隔
A_TrayMenu.Add("开机自启动", ToggleAutoStart)
A_TrayMenu.Add("暂停 / 恢复", PauseResume)
A_TrayMenu.Add("立即脉冲一次", PulseOnce)
A_TrayMenu.Add() ; 分隔
A_TrayMenu.Add("退出", (*) => ExitApp())

TryTrayIcon()
UpdateIntervalChecks()
UpdateTrayChecks()
SetOnlineTimer()  ; 初始计时器（默认关闭，随开关变化）

; ========= 函数 =========
ToggleKeepDisplayOn(*) {
  global state
  state["keepDisplayOn"] := !state["keepDisplayOn"]
  ApplyExecutionState(state["keepDisplayOn"])
  if (state["keepDisplayOn"]) {
    ShowTrayTip("已开启：保持常亮", "系统与显示将保持唤醒。", 1)
  } else {
    ShowTrayTip("已关闭：保持常亮", "恢复系统默认电源策略。", 1)
  }
  UpdateTrayChecks()
  UpdateTrayIcon()
}

ToggleKeepOnline(*) {
  global state
  state["keepOnline"] := !state["keepOnline"]
  SetOnlineTimer()
  if (state["keepOnline"]) {
    ShowTrayTip("已开启：保持在线", "将定期发送轻量输入脉冲。", 1)
  } else {
    ShowTrayTip("已关闭：保持在线", "不再发送输入脉冲。", 1)
  }
  UpdateTrayChecks()
  UpdateTrayIcon()
}

SetIntervalMs(ms, *) {
  global state
  state["intervalMs"] := ms
  UpdateIntervalChecks()
  SetOnlineTimer()
  ShowTrayTip("已设置间隔", "当前间隔：" . Round(ms/1000) . " 秒", 1)
}

CustomInterval(*) {
  global state
  input := InputBox("请输入间隔（秒）", "自定义间隔", "w250", Round(state["intervalMs"]/1000))
  if (input.Result = "Cancel")
    return
  secs := Integer(input.Value)
  if (secs <= 0) {
    MsgBox("请输入大于 0 的秒数。","提示","Icon!")
    return
  }
  SetIntervalMs(secs * 1000)
}

ToggleRandomize(*) {
  global state
  state["randomize"] := !state["randomize"]
  UpdateTrayChecks()
  SetOnlineTimer()
}

PauseResume(*) {
  global state
  if (state["keepOnline"]) {
    state["keepOnline"] := false
    SetOnlineTimer()
    ShowTrayTip("已暂停保持在线", "再次点击可恢复。", 1)
  } else {
    state["keepOnline"] := true
    SetOnlineTimer()
    ShowTrayTip("已恢复保持在线", "已重新开始发送脉冲。", 1)
  }
  UpdateTrayChecks()
  UpdateTrayIcon()
}

PulseOnce(*) {
  DoLightInputPulse()
  ShowTrayTip("已发送一次输入脉冲","用于立即刷新在线状态。",1)
}

ToggleAutoStart(*) {
  lnkPath := A_Startup "\KeepAwake.lnk"
  if FileExist(lnkPath) {
    FileDelete(lnkPath)
    ShowTrayTip("已关闭开机自启动", "启动项已移除。", 1)
  } else {
    FileCreateShortcut(A_ScriptFullPath, lnkPath)
    ShowTrayTip("已开启开机自启动", "已添加到启动文件夹。", 1)
  }
  UpdateTrayChecks()
}

SetOnlineTimer() {
  global state
  SetTimer(DoKeepOnlineTick, 0)  ; 先停
  if (state["keepOnline"]) {
    SetTimer(DoKeepOnlineTick, NextInterval())
  }
}

NextInterval() {
  global state, RANDOM_JITTER_MS
  base := state["intervalMs"]
  if (state["randomize"]) {
    jitter := Round(Random(-RANDOM_JITTER_MS, RANDOM_JITTER_MS))
    return Max(1000, base + jitter)
  }
  return base
}

DoKeepOnlineTick() {
  global state
  DoLightInputPulse()
  if (state["keepOnline"]) {
    SetTimer(DoKeepOnlineTick, NextInterval())
  } else {
    SetTimer(DoKeepOnlineTick, 0)
  }
}

DoLightInputPulse() {
  ; 方式 1：发送“无副作用”的 Shift（不改变文本内容）
  Send("{Shift}")
  ; 方式 2：极小幅鼠标移动（回到原位，不影响用户）
  CoordMode("Mouse", "Screen")
  MouseGetPos &x, &y
  DllCall("mouse_event", "UInt", 0x0001, "Int", 1, "Int", 0, "UInt", 0, "UPtr", 0) ; MOUSEEVENTF_MOVE
  MouseMove x, y, 0
}

ApplyExecutionState(enable) {
  if (enable) {
    flags := ES_CONTINUOUS | ES_DISPLAY_REQUIRED | ES_SYSTEM_REQUIRED
    DllCall("Kernel32.dll\SetThreadExecutionState", "UInt", flags, "UInt")
  } else {
    ; 仅传 ES_CONTINUOUS 取消保持
    DllCall("Kernel32.dll\SetThreadExecutionState", "UInt", ES_CONTINUOUS, "UInt")
  }
}

UpdateTrayChecks() {
  global state
  ; v2: Check/Uncheck 只能 1 个参数，这里按状态分别调用
  if (state["keepDisplayOn"])
    A_TrayMenu.Check("保持常亮（显示/系统）")
  else
    A_TrayMenu.Uncheck("保持常亮（显示/系统）")

  if (state["keepOnline"])
    A_TrayMenu.Check("保持在线（轻量输入脉冲）")
  else
    A_TrayMenu.Uncheck("保持在线（轻量输入脉冲）")

  if (state["randomize"])
    A_TrayMenu.Check("随机化间隔")
  else
    A_TrayMenu.Uncheck("随机化间隔")

  if (FileExist(A_Startup "\KeepAwake.lnk"))
    A_TrayMenu.Check("开机自启动")
  else
    A_TrayMenu.Uncheck("开机自启动")

  UpdateIntervalChecks()
}

UpdateIntervalChecks() {
  global state, intervalMenu, intervals
  for label, _ in intervals {
    intervalMenu.Uncheck(label)
  }
  for label, ms in intervals {
    if (ms = state["intervalMs"]) {
      intervalMenu.Check(label)
      break
    }
  }
}

TryTrayIcon() {
  try {
    TraySetIcon("shell32.dll", 44) ; 活跃风格
  }
}

UpdateTrayIcon() {
  global state
  if (state["keepDisplayOn"] || state["keepOnline"]) {
    try {
      TraySetIcon("shell32.dll", 44)
    }
  } else {
    try {
      TraySetIcon("shell32.dll", 167)
    }
  }
}

; ========= v2 兼容的托盘气泡封装 =========
; v2 的 TrayTip 不支持 "Tn" 超时字符串，这里用定时器在 sec 秒后清除。
ShowTrayTip(title, text, sec := 2) {
  TrayTip(title, text, "Iconi")  ; 只设置图标，不传超时
  if (sec > 0) {
    SetTimer(() => TrayTip(), -sec * 1000)  ; 负数=一次性定时器，触发时清除通知
  }
}
