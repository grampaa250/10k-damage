-- [[ Cargador Oficial ]] --
local modo = getgenv().script_mode

if modo == "PVP" then
    -- REEMPLAZA ESTA URL POR TU URL RAW DEL PASO 3
    https://raw.githubusercontent.com/grampaa250/10k-damage/fb89ec3b4eba04a60f77db132b16e389ff01f6dc/M1Burst.lua
else
    print("Modo no reconocido o vacio. Pon getgenv().script_mode = 'PVP'")
end
