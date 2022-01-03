Modules.Loader = {}
Modules.Loader.dictToLoadFirst = {
    {"ui_drift"},
}

function Modules.Loader.Run()
    while Modules.UI == nil do
        Wait(1)
    end
    for k,v in pairs(Modules.Loader.dictToLoadFirst) do
        Modules.UI.LoadStreamDict(v[1])
    end
end