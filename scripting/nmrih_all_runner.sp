#pragma semicolon 1
#pragma newdecls required

#include <sdkhooks>
#include <vscript_proxy>

#define     MAX_NORMAL_MODEL_COUNT                  9
#define     MAX_KID_MODEL_COUNT                     2
#define     MAX_MODEL_NAME_LEN                      40
#define     MAX_CLASSIC_NORMAL_ZOMBIE_HP            500
#define     MAX_NIGHTMARE_NORMAL_ZOMBIE_HP          1000
#define     MAX_CRAWLER_ZOMBIE_HP                   50

enum {
    DIFF_CLASSIC = 0,
    DIFF_NIGHTMARE
}

bool        g_plugin_enable;
bool        g_conversion_crawler;
int         g_set_health_normal
            , g_set_health_crawler
            , g_set_health_runner
            , g_set_health_kid
            , g_set_health_turned;
int         g_difficulty;                           // 0-classic   1-nightmare

public void OnPluginStart()
{
    ConVar convar;
    (convar = CreateConVar("sm_all_runner_enable",              "1", "Whether to enable the plugins")).AddChangeHook(On_ConVar_change);
    g_plugin_enable = convar.BoolValue;
    (convar = CreateConVar("sm_all_runner_transform_crawler",   "1", "Whether to transform the crawler")).AddChangeHook(On_ConVar_change);
    g_conversion_crawler = convar.BoolValue;
    (convar = CreateConVar("sm_all_runner_set_health_runner",   "0", "Set the runner HP (0=Auto match difficulty)")).AddChangeHook(On_ConVar_change);
    g_set_health_runner = convar.IntValue;
    (convar = CreateConVar("sm_all_runner_set_health_kid",      "0", "Set the kid HP (0=Auto match difficulty)")).AddChangeHook(On_ConVar_change);
    g_set_health_kid = convar.IntValue;
    (convar = CreateConVar("sm_all_runner_set_health_turned",   "0", "Set the turned HP (0=Auto match difficulty)")).AddChangeHook(On_ConVar_change);
    g_set_health_turned = convar.IntValue;
    (convar = CreateConVar("sm_all_runner_set_health_crawler",  "0", "Set the amount of health that crawler zombie converts to runner (0=Auto match difficulty)")).AddChangeHook(On_ConVar_change);
    g_set_health_crawler = convar.IntValue;
    (convar = CreateConVar("sm_all_runner_set_health_normal",   "0", "Set the amount of health that normal zombie converts to runner (0=Auto match difficulty)")).AddChangeHook(On_ConVar_change);
    g_set_health_normal = convar.IntValue;
    (convar = CreateConVar("sm_all_runner_runner_dmg_onehand",  "20", "Damage runner zombie does with one handed attacks")).AddChangeHook(On_ConVar_change);
    (convar = CreateConVar("sm_all_runner_runner_dmg_twohand",  "40", "Damage runner zombie does with two handed attacks")).AddChangeHook(On_ConVar_change);
    (convar = CreateConVar("sm_all_runner_kid_dmg_onehand",     "8",  "Damage kid zombie does with one handed attacks")).AddChangeHook(On_ConVar_change);
    (convar = CreateConVar("sm_all_runner_kid_dmg_twohand",     "16", "Damage kid zombie does with two handed attacks")).AddChangeHook(On_ConVar_change);
    AutoExecConfig();

    char dif[32];
    (convar = FindConVar("sv_difficulty")).AddChangeHook(On_ConVar_change);
    convar.GetString(dif, 32);
    if( strcmp(dif, "nightmare") == 0 )             g_difficulty = 1;
    else                                            g_difficulty = 0;
}

public void On_ConVar_change(ConVar convar, const char[] oldValue, const char[] newValue)
{
    if ( convar == INVALID_HANDLE ) return;
    char convar_Name[64];
    convar.GetName(convar_Name, 64);

    if( strcmp(convar_Name, "sv_difficulty") == 0 ) {
        if( strcmp(newValue, "nightmare") == 0 )    g_difficulty = 1;
        else                                        g_difficulty = 0;
    }
    else if( strcmp(convar_Name, "sm_all_runner_enable") == 0 ) {
        g_plugin_enable = convar.BoolValue;
    }
    else if( strcmp(convar_Name, "sm_all_runner_conversion_crawler") == 0 ) {
        g_conversion_crawler = convar.BoolValue;
    }
    else if( strcmp(convar_Name, "sm_all_runner_set_health_runner") == 0 ) {
        g_set_health_runner = convar.IntValue;
    }
    else if( strcmp(convar_Name, "sm_all_runner_set_health_kid") == 0 ) {
        g_set_health_kid = convar.IntValue;
    }
    else if( strcmp(convar_Name, "sm_all_runner_set_health_turned") == 0 ) {
        g_set_health_turned = convar.IntValue;
    }
    else if( strcmp(convar_Name, "sm_all_runner_set_health_crawler") == 0 ) {
        g_set_health_crawler = convar.IntValue;
    }
    else if( strcmp(convar_Name, "sm_all_runner_set_health_normal") == 0 ) {
        g_set_health_normal = convar.IntValue;
    }
    else if( strcmp(convar_Name, "sm_all_runner_runner_dmg_onehand") == 0 ) {
        FindConVar("sv_runner_dmg_onehand").SetInt(convar.IntValue);
    }
    else if( strcmp(convar_Name, "sm_all_runner_runner_dmg_twohand") == 0 ) {
        FindConVar("sv_runner_dmg_twohand").SetInt(convar.IntValue);
    }
    else if( strcmp(convar_Name, "sm_all_runner_kid_dmg_onehand") == 0 ) {
        FindConVar("sv_kid_dmg_onehand").SetInt(convar.IntValue);
    }
    else if( strcmp(convar_Name, "sm_all_runner_kid_dmg_twohand") == 0 ) {
        FindConVar("sv_kid_dmg_twohand").SetInt(convar.IntValue);
    }
}

public void OnEntityCreated(int entity, const char[] classname)
{
    if( g_plugin_enable && entity > MaxClients && IsValidEntity(entity) )
    {
        if( String_EndsWith(classname, "zombie") ) {
            SDKHook(entity, SDKHook_SpawnPost, SDKHookCB_ZombieSpawnPost);
        }
        // if( String_EndsWith(classname, "shamblerzombie") ) {        // npc_nmrih_shamblerzombie
        //     SDKHook(entity, SDKHook_SpawnPost, SDKHookCB_ZombieSpawnPost);
        // }
        // else if( String_EndsWith(classname, "runnerzombie") ) {     // npc_nmrih_runnerzombie
        //     if( g_set_health_runner != 0 )
        //         SetEntProp(entity, Prop_Data, "m_iHealth", g_set_health_runner);
        // }
        // else if( String_EndsWith(classname, "kidzombie") ) {        // npc_nmrih_kidzombie
        //     if( g_set_health_kid != 0 )
        //         SetEntProp(entity, Prop_Data, "m_iHealth", g_set_health_kid);
        // }
        // else if( String_EndsWith(classname, "turnedzombie") ) {     // npc_nmrih_turnedzombie
        //     if( g_set_health_turned != 0 )
        //         SetEntProp(entity, Prop_Data, "m_iHealth", g_set_health_turned);
        // }
    }
}

public void SDKHookCB_ZombieSpawnPost(int zombie_index)
{
    SDKUnhook(zombie_index, SDKHook_SpawnPost, SDKHookCB_ZombieSpawnPost);
    if( ! IsValidEntity(zombie_index) || ( ! check_is_normal_zombie_model(zombie_index) && ! check_is_kid_zombie_model(zombie_index)) ) {
        return ;
    }
    if( ( g_set_health_runner != 0 || g_set_health_turned != 0 ) && RunEntVScriptBool(zombie_index, "IsRunner()") ) {
        if( RunEntVScriptBool(zombie_index, "IsTurned()") ) {
            if( g_set_health_turned != 0 )
                SetEntProp(zombie_index, Prop_Data, "m_iHealth", g_set_health_turned);
        }
        else if( g_set_health_runner != 0 )
            SetEntProp(zombie_index, Prop_Data, "m_iHealth", g_set_health_runner);
    }
    else if( g_set_health_kid != 0 && RunEntVScriptBool(zombie_index, "IsKid()") ) {
        SetEntProp(zombie_index, Prop_Data, "m_iHealth", g_set_health_kid);
    }
    else if( RunEntVScriptBool(zombie_index, "IsCrawler()") ) {
        static int health;
        health = GetEntProp(zombie_index, Prop_Data, "m_iHealth", 1);
        if( g_conversion_crawler && (health == MAX_CRAWLER_ZOMBIE_HP) ) {
            RunEntVScript(zombie_index, "BecomeRunner()");
            DispatchKeyValue(zombie_index, "classname", "npc_nmrih_runnerzombie");
            SetEntProp(zombie_index, Prop_Data, "m_iHealth",
                g_set_health_crawler != 0 ? g_set_health_crawler : (350 * ((g_difficulty == DIFF_NIGHTMARE) ? 2 : 1)) );
        }
    }
    else {
        static int health;
        health = GetEntProp(zombie_index, Prop_Data, "m_iHealth", 1);
        if( health == MAX_CLASSIC_NORMAL_ZOMBIE_HP || health == MAX_NIGHTMARE_NORMAL_ZOMBIE_HP )
        {
            RunEntVScript(zombie_index, "BecomeRunner()");
            DispatchKeyValue(zombie_index, "classname", "npc_nmrih_runnerzombie");
            if( g_set_health_normal != 0 )
                SetEntProp(zombie_index, Prop_Data, "m_iHealth", g_set_health_normal);
        }
    }
}

bool check_is_normal_zombie_model(int entity)
{
    static const char normal_model[][] = {
        "models/nmr_zombie/national_guard.mdl",
        "models/nmr_zombie/berny.mdl",
        "models/nmr_zombie/casual_02.mdl",
        "models/nmr_zombie/herby.mdl",
        "models/nmr_zombie/jogger.mdl",
        "models/nmr_zombie/julie.mdl",
        "models/nmr_zombie/maxx.mdl",
        "models/nmr_zombie/officezom.mdl",
        "models/nmr_zombie/tammy.mdl"
    };
    static int normal_model_index;
    static const int normal_model_len[] = {32, 23, 27, 23, 24, 23, 22, 27, 23};

    static char entity_model[MAX_MODEL_NAME_LEN];
    static int entity_model_index, entity_model_len;

    GetEntPropString(entity, Prop_Data, "m_ModelName", entity_model, MAX_MODEL_NAME_LEN);
    entity_model_len = strlen(entity_model) - 4;

    static int ikun;
    for( ikun = 0; ikun < MAX_NORMAL_MODEL_COUNT; ++ikun )
    {
        entity_model_index = entity_model_len;
        normal_model_index = normal_model_len[ikun];
        static int match_count;
        static const int max_match_len = 14;
        match_count = 0;

        while( entity_model_index > 0 && normal_model_index > 0 && ++match_count <= max_match_len ) {
            if( entity_model[--entity_model_index] != normal_model[ikun][--normal_model_index] )
                break;
            // if( entity_model[entity_model_index] == '/' )
            //     return true;
        }
        if( match_count == max_match_len + 1 )
            return true;
    }
    return false;
}

bool check_is_kid_zombie_model(int entity)
{
    static const char kid_model[][] = {
        "models/nmr_zombie/zombiekid_boy.mdl",
        "models/nmr_zombie/zombiekid_girl.mdl"
    };
    static int kid_model_index;
    static const int kid_model_len[] = {31, 32};

    static char entity_model[MAX_MODEL_NAME_LEN];
    static int entity_model_index, entity_model_len;

    GetEntPropString(entity, Prop_Data, "m_ModelName", entity_model, MAX_MODEL_NAME_LEN);
    entity_model_len = strlen(entity_model) - 4;

    static int ikun;
    for( ikun = 0; ikun < MAX_KID_MODEL_COUNT; ++ikun )
    {
        entity_model_index = entity_model_len;
        kid_model_index = kid_model_len[ikun];
        static int match_count;
        static const int max_match_len = 14;
        match_count = 0;

        while( entity_model_index > 0 && kid_model_index > 0 && ++match_count <= max_match_len ) {
            if( entity_model[--entity_model_index] != kid_model[ikun][--kid_model_index] )
                break;
            // if( entity_model[entity_model_index] == '/' )
            //     return true;
        }
        if( match_count == max_match_len + 1 )
            return true;
    }
    return false;
}

stock bool String_EndsWith(const char[] str, const char[] subStr)
{
    int n_str = strlen(str);
    int n_subStr = strlen(subStr);
    if( n_str < n_subStr ) 	return false;

    while( n_str > 0 && n_subStr > 0 ) {
        if( str[--n_str] != subStr[--n_subStr] )
            return false;
    }
    return true;
}
