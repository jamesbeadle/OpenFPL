  
import T "../OpenFPL_backend/types";
import List "mo:base/List";

module GenesisData {
    
    public func get_genesis_seasons(): [T.Season] {
        return [
        ]
    }; 
    
    public func get_genesis_teams(): [T.Team] {
        return [
            { id = 1; name = "Arsenal"; primaryColourHex = "#f00000"; secondaryColourHex = "#ffffff"; friendlyName = "Arsenal"; abbreviatedName = "ARS"; },
            { id = 2; name = "Aston Villa"; primaryColourHex = "#7d1142"; secondaryColourHex = "#ffffff"; friendlyName = "Aston Villa"; abbreviatedName = "AVL"; },
            { id = 3; name = "AFC Bournemouth"; primaryColourHex = "#d71921"; secondaryColourHex = "#ffffff"; friendlyName = "Bournemouth"; abbreviatedName = "BOU"; },
            { id = 4; name = "Brentford"; primaryColourHex = "#c10000"; secondaryColourHex = "#ffffff"; friendlyName = "Brentford"; abbreviatedName = "BRE"; },
            { id = 5; name = "Brighton & Hove Albion"; primaryColourHex = "#004b95"; secondaryColourHex = "#ffffff"; friendlyName = "Brighton"; abbreviatedName = "BRI"; },
            { id = 6; name = "Burnley"; primaryColourHex = "#5e1444"; secondaryColourHex = "#f2f2f2"; friendlyName = "Burnley";  abbreviatedName = "BUR";},
            { id = 7; name = "Chelsea"; primaryColourHex = "#001b71"; secondaryColourHex = "#ffffff"; friendlyName = "Chelsea";  abbreviatedName = "CHE";},
            { id = 8; name = "Crystal Palace"; primaryColourHex = "#e91d12"; secondaryColourHex = "#0055a5"; friendlyName = "Crystal Palace";  abbreviatedName = "CRY";},
            { id = 9; name = "Everton"; primaryColourHex = "#0a0ba1"; secondaryColourHex = "#ffffff"; friendlyName = "Everton";  abbreviatedName = "EVE";},
            { id = 10; name = "Fulham"; primaryColourHex = "#000000"; secondaryColourHex = "#e5231b"; friendlyName = "Fulham";  abbreviatedName = "FUL";},
            { id = 11; name = "Liverpool"; primaryColourHex = "#dc0714"; secondaryColourHex = "#ffffff"; friendlyName = "Liverpool";  abbreviatedName = "LIV";},
            { id = 12; name = "Luton Town"; primaryColourHex = "#f36f24"; secondaryColourHex = "#fefefe"; friendlyName = "Luton";  abbreviatedName = "LUT";},
            { id = 13; name = "Manchester City"; primaryColourHex = "#98c5e9"; secondaryColourHex = "#ffffff"; friendlyName = "Man City";  abbreviatedName = "MCI";},
            { id = 14; name = "Manchester United"; primaryColourHex = "#c70101"; secondaryColourHex = "#ffffff"; friendlyName = "Man United";  abbreviatedName = "MUN";},
            { id = 15; name = "Newcastle United"; primaryColourHex = "#000000"; secondaryColourHex = "#ffffff"; friendlyName = "Newcastle";  abbreviatedName = "NEW";},
            { id = 16; name = "Nottingham Forest"; primaryColourHex = "#c8102e"; secondaryColourHex = "#efefef"; friendlyName = "Nottingham Forest";  abbreviatedName = "NFO";},
            { id = 17; name = "Sheffield United"; primaryColourHex = "#e20c17"; secondaryColourHex = "#1d1d1b"; friendlyName = "Sheffield United";  abbreviatedName = "SHE";},
            { id = 18; name = "Tottenham Hotspur"; primaryColourHex = "#ffffff"; secondaryColourHex = "#0b0e1e"; friendlyName = "Tottenham";  abbreviatedName = "TOT";},
            { id = 19; name = "West Ham United"; primaryColourHex = "#7c2c3b"; secondaryColourHex = "#2dafe5"; friendlyName = "West Ham";  abbreviatedName = "WHU";},
            { id = 20; name = "Wolverhampton Wanderers"; primaryColourHex = "#fdb913"; secondaryColourHex = "#231f20"; friendlyName = "Wolves";  abbreviatedName = "WOL";}
        ];
    };

    public func get_genesis_players(): [T.Player] {
        return [];
    };
    
}
