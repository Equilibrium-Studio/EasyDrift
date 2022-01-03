Modules.Loader = {}
Modules.Loader.ThingsToLoad = 0
Modules.Loader.LoadedCount = 0
Modules.Loader.CurrentLoading = ""
Modules.Loader.dictToLoadFirst = {
    --{"ui_loader"},
}
Modules.Loader.dictToLoad = { -- Maybe used in the futur
    --{"ui_lobby"},
}
Modules.Loader.fontToLoad = {
    --{"bo", "Black ops"},
}

Modules.Loader.ModelsToLoad = {

}

function Modules.Loader.Run()
    Modules.Loader.ThingsToLoad = 0
    Modules.Loader.LoadedCount = 0
    for k,v in pairs(Modules.Loader.dictToLoadFirst) do
        Modules.Loader.ThingsToLoad = Modules.Loader.ThingsToLoad + 1
    end

    for k,v in pairs(Modules.Loader.dictToLoad) do
        Modules.Loader.ThingsToLoad = Modules.Loader.ThingsToLoad + 1
    end

    for k,v in pairs(Modules.Loader.fontToLoad) do
        Modules.Loader.ThingsToLoad = Modules.Loader.ThingsToLoad + 1
    end

    for k,v in pairs(Modules.Loader.ModelsToLoad) do
        Modules.Loader.ThingsToLoad = Modules.Loader.ThingsToLoad + 1
    end

    for k,v in pairs(Modules.Loader.dictToLoadFirst) do
        Modules.UI.LoadStreamDict(v[1])
        Modules.Loader.LoadedCount = Modules.Loader.LoadedCount + 1
    end

    for k,v in pairs(Modules.Loader.fontToLoad) do
        Modules.Loader.CurrentLoading = v[2]
        Modules.UI.LoadFont(v)
        Modules.Loader.LoadedCount = Modules.Loader.LoadedCount + 1
    end

    for k,v in pairs(Modules.Loader.dictToLoad) do
        Modules.Loader.CurrentLoading = v[1]
        Modules.UI.LoadStreamDict(v[1])
        Modules.Loader.LoadedCount = Modules.Loader.LoadedCount + 1
    end

    for k,v in pairs(Modules.Loader.ModelsToLoad) do
        Modules.Loader.CurrentLoading = v[1]
        Modules.World.LoadModel(v[1])
        Modules.Loader.LoadedCount = Modules.Loader.LoadedCount + 1
    end
end