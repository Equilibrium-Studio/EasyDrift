# EasyDrift
## A simple drift counter
[![Image](https://discordapp.com/api/guilds/926120299232112671/widget.png?style=shield)](https://discord.gg/fhgc3s8HzS)

EasyDrift is a simple drift counter that also provides a multitude of events and functions to integrate the system with your own HUD

- Drag and drop if you don't want to loose time !
- Easy integration with your own HUD
- Pre made HUD *inspired* by forza

![image](https://user-images.githubusercontent.com/19718604/147981053-ff53de8e-39bb-4d84-9b1a-bc2830101fe5.png)


## Events (Client side)

EasyDrift provides a list of events to use to integrate the system with your framework or HUD. Want to give money as a reward to your players after a great drift? It's possible!
Each event name can be changed in the resource's config file.


| Event | Default event name | Argument passed |
| ------ | ------ | ------ |
| Start drifting | drift:start | none |
| Stop drifting | drift:finish | 1: final score |

Some events are also available to retrieve information

`drift:GetCurrentDriftScore`
Get the current drift score
```
-- Exemple usage
TriggerEvent("drift:GetCurrentDriftScore", function(score)
    print("My score is: ", score) 
end)
```

`drift:IsDrifting`
Get if the player is drifting or not
```
-- Exemple usage
TriggerEvent("drift:IsDrifting", function(isDrifting)
    print("Am i drifitng ? ", isDrifting) 
end)
```


# Advanced developer

A global export is also available allowing you to access all the variables / functions of the code from another resource. I don't recommend to use this if you are not sure of what you are doing.
Export name `GetModules`
```
-- Exemple usage
local Modules = exports[‘EasyDrift’]:GetModules()
print(Modules.DriftCounter.CurrentPoints)
```


# Support

[![Discord2](https://discordapp.com/api/guilds/926120299232112671/widget.png?style=banner4)](https://discord.gg/fhgc3s8HzS)
