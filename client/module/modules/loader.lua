Modules.Loader = {}
Modules.Loader.dictToLoadFirst = {
    --{"ui_loader"},
}

function Modules.Loader.Run()
    for k,v in pairs(Modules.Loader.dictToLoadFirst) do
        Modules.UI.LoadStreamDict(v[1])
    end
end