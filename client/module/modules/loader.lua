Modules.Loader = {}
Modules.Loader.dictToLoadFirst = {
    {"ui_drift"},
}
Modules.Loader.FontToLoad = {
    {"forza", "forza"},
}

function Modules.Loader.Run()
    while Modules.UI == nil do
        Wait(1)
    end
    for k,v in pairs(Modules.Loader.dictToLoadFirst) do
        Modules.UI.LoadStreamDict(v[1])
    end
    for k,v in pairs(Modules.Loader.FontToLoad) do
        Modules.UI.LoadFont(v)
    end
end