# Fun fact: you can run PowerShell scripts on Linux!

$pesdeHome = if ($env:PESDE_HOME) { $env:PESDE_HOME } else { Join-Path $HOME ".pesde" }
$pesdeBin = Join-Path $pesdeHome "bin"

function Get-PesdeExe([string]$name) {
    $path = Join-Path $pesdeBin ("{0}.exe" -f $name)
    if (-not (Test-Path $path)) {
        throw "Missing $name in $pesdeBin. Run 'pesde install' first."
    }
    return $path
}

$rojo = Get-PesdeExe "rojo"
$stylua = Get-PesdeExe "stylua"
$selene = Get-PesdeExe "selene"
$luauLsp = Get-PesdeExe "luau_lsp"
$darklua = Get-PesdeExe "darklua"

& $rojo sourcemap . | Out-File .meta/sourcemap.json -Encoding utf8 # Needed if you want some types for packages
& $stylua src -f .meta/.stylua.toml
& $selene src --config .meta/selene.toml
Invoke-WebRequest https://raw.githubusercontent.com/JohnnyMorganz/luau-lsp/main/scripts/globalTypes.d.lua -OutFile ./roblox.d.luau
& $luauLsp analyze --settings .vscode/settings.json --definitions "@roblox=./roblox.d.luau" --ignore /roblox_packages/** src
& $darklua process src/init.luau dist.lua -c .meta/.darklua.json # This is the main thing, make sure you at least run this
Remove-Item roblox.d.luau
