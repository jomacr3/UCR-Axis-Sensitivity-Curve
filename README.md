# UCR-Axis-Sensitivity-Curve
A custom plugin written for UCR with vJoy. It is meant to increase the sensitivity of an axis as it moves further from its center. It maps its output to a vJoy stick axis.
The main feature of this plugin is the cubic function that dynamically changes "sensitivity" as the axis moves further from the sensor.
(Note: this profile was originally made for the Thrustmaster Nascar Pro Force Feedback with no gear shift. For this device set sensitivity to 400% in the UCR GUI)

Usage instructions:
Add the .ahk file to your UCR files under the directory <UCR install directory>\UCR\Plugins\User
Every input device is different and will likely require trial and error with the sensitivity multiplier in the UCR GUI. 

If you want to change the cubic function itself, the easiest way to change this function is to graph the function in Desmos or similar graphing software to visualize the output. 
Example using the function uploaded:
; Apply a cubic curve
value := value ** 3 + value * 100
; Normalize the value
value := value / (10000)

In Desmos this would be:  y = (x^3 +100x) / 10000

having the intercepts (100, 100) and (-100, -100) or close is a good sign your function will be successful.
