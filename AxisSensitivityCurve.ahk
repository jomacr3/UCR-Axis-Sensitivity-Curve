/*
Remaps a physical joystick axis to a virtual joystick axis
Requires the StickOps library and the vJoy library
*/
class AxisToModAxis extends _UCR.Classes.Plugin {
    Type := "Remapper (Axis To Mod Axis)"
    Description := "Maps an axis input to a virtual axis output"
    vAxis := 0
    vDevice := 0
    ; Set up the GUI to allow the user to select input and output axes
    Init(){
        Gui, Add, Text, % "xm w125 Center", Input Axis
        Gui, Add, Text, % "x+5 yp w100 Center", Input Preview
        Gui, Add, Text, % "x+5 yp w40 Center", Invert
        Gui, Add, Text, % "x+5 yp w40 Center", Deadzone
        Gui, Add, Text, % "x+5 yp w40 Center", Sensitivity
        Gui, Add, Text, % "x+5 yp w30 Center", Linear
        Gui, Add, Text, % "x+10 yp w125 Center", Output Virtual Axis
        Gui, Add, Text, % "x+5 yp w100 Center", Output Preview
        
        ;this.AddInputAxis("InputAxis", 0, this.MyInputChangedState.Bind(this), "xm w125")
        this.AddControl("InputAxis", "IA1", 0, this.MyInputChangedState.Bind(this), "xm w125")
        this.AddControl("AxisPreview", "", 0, this.IOControls.IA1, "x+5 yp w100", 50)
        ;this.AddControl("Invert", 0, "CheckBox", "x+20 yp+3 w30")
        this.AddControl("CheckBox", "Invert", 0, "x+20 yp+3 w30")
        ;this.AddControl("Deadzone", 0, "Edit", "x+10 yp-3 w30", "0")
        this.AddControl("Edit", "Deadzone", 0, "x+10 yp-3 w30", "0")
        Gui, Add, Text, % "x+0 yp+3", `%
        ;this.AddControl("Sensitivity", 0, "Edit", "x+10 yp-3 w30", "100")
        this.AddControl("Edit", "Sensitivity", 0, "x+10 yp-3 w30", "100")
        Gui, Add, Text, % "x+0 yp+3", `%
        ;this.AddControl("Linear", 0, "Checkbox", "x+18 yp w30")
        this.AddControl("Checkbox", "Linear", 0, "x+18 yp w30")
        ;this.AddControl("OutputAxis", "OA1", this.MyOutputChangedValue.Bind(this), "x+5 yp-3 w125")
        this.AddControl("OutputAxis", "OA1", this.MyOutputChangedValue.Bind(this), "x+5 yp-3 w125")
        this.AddControl("AxisPreview", "", 0, this.IOControls.OA1, "x+5 yp w100", 50)
    }
    
    ; The user changed options - store stick and axis selected for fast retrieval
    MyOutputChangedValue(value){
        this.vAxis := value.Binding[1]
        this.vDevice := value.DeviceID
        this.OutputBound := value.IsBound()
    }
    
    ; The user moved the selected input axis. Manipulate the output axis accordingly
    MyInputChangedState(value){
        value := UCR.Libraries.StickOps.AHKToInternal(value)
        if (this.OutputBound){
            if (this.GuiControls.Deadzone.Get()){
                value := UCR.Libraries.StickOps.Deadzone(value, this.GuiControls.Deadzone.Get())
            }
            if (this.GuiControls.Sensitivity.Get()){
                value := this.ApplyNonLinearSensitivity(value, this.GuiControls.Sensitivity.Get())
            }
            if (this.GuiControls.Invert.Get()){
                value := UCR.Libraries.StickOps.Invert(value)
            }
            value := UCR.Libraries.StickOps.InternalToAHK(value)
            this.IOControls.OA1.Set(value)
        }
    }

    ; Apply a cubic curve for non-linear sensitivity adjustment and normalize
    ApplyNonLinearSensitivity(value, sensitivity){
        ; Apply a cubic curve
        value := value ** 3 + value * 100
        ; Normalize the value
        value := value / (10000)
        return value * (sensitivity / 100)
    }
}
