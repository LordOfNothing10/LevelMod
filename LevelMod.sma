/* 
	LevelMod @ 2012 by LordOfNothinG

	This project has been started in 2011 now, latest update has been
	made in 2014, i hope you will enjoy my latest version of levelmod

	This software is a free / public software and is illegal to edit
	or sell or made money with him, For more info, plugins please visit:
			

			www.ultracs.ro/forum
*/

#include <amxmodx>
#include <amxmisc>
#include <fun>
#include <hamsandwich>
#include <nvault>
#include <cstrike>
#include <fakemeta>


/*		Leve Mod ConfiGurare !		*/



#define TAG "Level Mod"
#define MAX_LEVEL	200
#define SPEED_PER_LEVEL		3
#define DAMAGE_PER_LEVEL	10


/*		De aici incepem codatul !	*/




// 	Plugin Info !

new const PLUGIN_NAME[] = "Level Mod";
new const AUTHOR[] = "LordOfNothinG";
new const hnsxp_version[] = "6.1";


new const LEVELS[MAX_LEVEL + 1] = {
        
        1000, // 1
        3000, // 2
        5000, // 3
        7000, // 4
        9000, // 5
        10000, // 6
        15000, // 7
        20000, // 8
        25000, // 10
        30000, // 11
        40000, // 12
        50000, // 13
        60000, // 14
        70000, // 15
        100000, // 16
        120000, // 17
        130000, // 18
        150000, // 19
        200000, // 20
        250000, // 21
        300000, // 22
        350000, // 23
        400000, // 24
        450000, // 25
        500000, // 26
        600000, // 27
        700000, // 28
        800000, // 29
        1000000, // 30
        1200000, // 31
        1300000, //32
        1400000, // 33
        1500000, // 34
        1600000, // 35
        1700000, // 36
        1800000, // 37
        1900000, // 38
        1950000, // 39
        2000000, // 40
        2500000, // 41
        3000000, // 42
        3500000, // 43
        4000000, // 44
        5000000, // 45
        6000000, // 46
        7000000, // 47
        8000000, // 48
        9000000, // 49
        10000000, // 50
        13000000, // 51
        15000000, // 2
        18000000, // 3
        20000000, // 4
        22500000, // 5
        25000000, // 6
        27500000, // 7
        29000000, // 8
        30000000, // 10
        35000000, // 11
        40000000, // 12
        45000000, // 13
        50000000, // 14
        55000000, // 15
        60000000, // 16
        65000000, // 17
        70000000, // 18
        75000000, // 19
        85000000, // 20
        90000000, // 21
        100000000, // 22
        110000000, // 23
        220000000, // 24
        230000000, // 25
        240000000, // 26
        250000000, // 27
        260000000, // 28
        270000000, // 29
        280000000, // 30
        290000000, // 31
        300000000, //32
        400000000, // 33
        500000000, // 34
        600000000, // 35
        700000000, // 36
        800000000, // 37
        900000000, // 38
        1000000000, // 39
        1500000000, // 40
        2000000000, // 41
        3000000000, // 42
        4000000000, // 43
        5000000000, // 44
        6000000000, // 45
        7000000000, // 46
        7500000000, // 47
        8500000000, // 48
        9099090000, // 97
        10000000000, // 98
        10000500000, // 99
        20000000000, // 100
	20000100000, // 1
        20000110000,// 2
        20000130000,
        20000134000,
        20000135000,
        20000136000,
        20000138000,
        20000139000,
        20000113000,
        20000213000,
        20000313000,
	20000413000,
        20000513000,
        20000613000,
        20000713000,
        20000813000,
        20000913000,
        20001113000,
        20002113000,
        20003113000,
        20004113000,
        20005113000,
        20006113000,
        20007113000,
        20008113000,
        20009113000,
        20011113000,
        20021113000,
        20031113000,
        20041113000,
        20051113000,
        20061113000,
        20071113000,
        20081113000,
        20091113000,
        20101113000,
        20201113000,
        20301113000,
        20401113000,
        20501113000,
        20601113000,
        20701113000,
        20901113000,
        21101113000,
        22101113000,
        23101113000,
        24101113000,
        25101113000,
        26101113000,
        27101113000,
 	27101115000, // 1
        27101116000, // 2
        27102111300, // 3
        27105111300, // 4
        27107111300, // 5
        27108111300, // 6
        27109111300, // 7
        27112111300, // 8
        27122111300, // 10
        27132111300, // 11
        27142111300, // 12
        27152111300, // 13
        27162111300, // 14
        27172111300, // 15
        27182111300, // 16
        27192111300, // 17
        27202111300, // 18
        27302111300, // 19
        27402111300, // 20
        27502111300, // 21
        27602111300, // 22
        27802111300, // 23
        27902111300, // 24
        28102111300, // 25
        29102111300, // 26
        29202111300, // 27
        29302111300, // 28
        29402111300, // 29
        29502111300, // 30
        29602111300, // 31
        29702111300, //32
        29802111300, // 33
        29902111300, // 34
        39102111300, // 35
        49102111300, // 36
        59102111300, // 37
        69102111300, // 38
        79102111300, // 39
        89102111300, // 40
        99102111300, // 41
        129102111300, // 42
        139102111300, // 43
        149102111300, // 44
        159102111300, // 45
        169102111300, // 46
        179102111300, // 47
        189102111300, // 48
        199102111300, // 49
        229102111300, // 50
	329102111300, // 50
	999999999999999999999999999999999 
}
new hnsxp_playerxp[33], hnsxp_playerlevel[33];
new g_hnsxp_vault, wxp, xlevel;

#define is_user_vip(%1)		( get_user_flags(%1) & ADMIN_IMMUNITY )
#define IsPlayer(%1) ( 1 <= %1 <=  g_iMaxPlayers )
new g_iMaxPlayers



const m_LastHitGroup = 75;

enum Color
{
	NORMAL = 1, // clients scr_concolor cvar color
	YELLOW = 1, // NORMAL alias
	GREEN, // Green Color
	TEAM_COLOR, // Red, grey, blue
	GREY, // grey
	RED, // Red
	BLUE, // Blue
}
 
new TeamName[][] =
{
	"",
	"TERRORIST",
	"CT",	
	"SPECTATOR"
}


public plugin_init()
{
        register_plugin(PLUGIN_NAME, hnsxp_version, AUTHOR);

        RegisterHam(Ham_Spawn, "player", "hnsxp_spawn", 1);
	RegisterHam(Ham_Killed, "player", "hnsxp_playerdie", 1);

        register_clcmd("say /level","plvl");
        register_clcmd("say /xp","plvl");

        register_clcmd("say_team /xp","plvl");

        register_clcmd("say /lvl","tlvl");
        g_hnsxp_vault = nvault_open("levelmod_vault");
       

        register_event("SendAudio", "t_win", "a", "2&%!MRAD_terwin")

        xlevel = CreateMultiForward("PlayerMakeNextLevel", ET_IGNORE, FP_CELL);
        wxp = CreateMultiForward("PlayerIsHookXp", ET_IGNORE, FP_CELL);
        register_forward(FM_ClientUserInfoChanged, "ClientUserInfoChanged")
	
	g_iMaxPlayers = get_maxplayers ( )
	RegisterHam ( Ham_TakeDamage, "player", "Ham_CheckDamage_Bonus");
	RegisterHam ( Ham_Item_PreFrame, "player", "Ham_CheckSpeed_Bonus", 1);

	set_task(120.0,"LevelMod_msg",0,"",0,"b",0)
}

public Player_TakeDamage ( iVictim, iInflictor, iAttacker, Float:fDamage ) {
    
	if ( iInflictor == iAttacker && IsPlayer ( iAttacker ) ) 
	{
    
		SetHamParamFloat ( 4, fDamage + DAMAGE_PER_LEVEL * hnsxp_playerlevel[iAttacker] );
		return HAM_HANDLED;
       	}
    
	return HAM_IGNORED;
    
}

public LevelMod_msg(id)
{
	ColorChat(0, TEAM_COLOR, "^1[ ^3%s^1 ] ^4%s^1 by ^3%s^1 versiune ^4%s^1 !",TAG,PLUGIN_NAME,AUTHOR,hnsxp_version)
}

/*      Speed Check      */
public Ham_CheckSpeed_Bonus( id )
{
	if( !is_user_alive( id ) )
	{
		return HAM_IGNORED;
	}
	
	set_user_maxspeed( id, 250.0 + SPEED_PER_LEVEL * hnsxp_playerlevel[ id ] );
			
	return HAM_IGNORED;
}

public GiveExp(index)
{
	switch(hnsxp_playerlevel[index])
	{
		case 0..10:
		{
			hnsxp_playerxp[index] = hnsxp_playerxp[index] + 1000;
		}

		case 11..20:
		{
			hnsxp_playerxp[index] = hnsxp_playerxp[index] + 5000;
		}
		case 21..30:
		{
			hnsxp_playerxp[index] = hnsxp_playerxp[index] + 15040;
		}

		case 31..40:
		{
			hnsxp_playerxp[index] = hnsxp_playerxp[index] + 25030;
		}

		case 41..50:
		{
			hnsxp_playerxp[index] = hnsxp_playerxp[index] + 45060;
		}

		case 51..80:
		{
			hnsxp_playerxp[index] = hnsxp_playerxp[index] + 150000;
		}

		case 81..100:
		{
			hnsxp_playerxp[index] = hnsxp_playerxp[index] + 1800500;
		}

		case 101..150:
		{
			hnsxp_playerxp[index] = hnsxp_playerxp[index] + 900050600;
		}
		case 151..200:
		{
			hnsxp_playerxp[index] = hnsxp_playerxp[index] + 9900050600;
		}

		default:
		{
			hnsxp_playerxp[index] = hnsxp_playerxp[index] + 0;
		}
	}
}
public ClientUserInfoChanged(id)
{
        static const name[] = "name"
        static szOldName[32], szNewName[32]
        pev(id, pev_netname, szOldName, charsmax(szOldName))
        if( szOldName[0] )
        {
                get_user_info(id, name, szNewName, charsmax(szNewName))
                if( !equal(szOldName, szNewName) )
                {
                        set_user_info(id, name, szOldName)
                        return FMRES_HANDLED
                }
        }
        return FMRES_IGNORED
}

public plugin_natives()
{
        register_native("get_user_xp","_get_user_xp");
        register_native("get_user_level","_get_user_level");
        register_native("set_user_xp","_set_user_xp");
        register_native("set_user_level","_set_user_level");
}

public _get_user_xp(plugin, params)
{
        return hnsxp_playerxp[get_param(1)];
}

public _get_user_level(plugin, params)
{
        return hnsxp_playerlevel[get_param(1)];
}

public _set_user_xp(plugin, xer)
{
	new id = get_param(1)
	new value = get_param(2)

	if(is_user_connected(id))
	{
		hnsxp_playerxp[id] = value;
		return 0
	}

	else
	{
		log_error(AMX_ERR_NATIVE,"User %d is not connected !",id)
		return 0
	}
	return 1
}


public _set_user_level(plugin, eat)
{
	new id = get_param(1)
	new valuex = get_param(2)

	if(is_user_connected(id))
	{
		hnsxp_playerlevel[id] = valuex;
		return 0
	}

	else
	{
		log_error(AMX_ERR_NATIVE,"User %d is not connected !",id)
		return 0
	}
	return 1
}

public gItem(id)
{

        new dgl = give_item(id, "weapon_deagle")

        if(is_user_alive(id))
        {
                switch(hnsxp_playerlevel[id])
                {
                
                        case 0:
                        {
                                cs_set_weapon_ammo(dgl, 1);
                                ColorChat(id, TEAM_COLOR,"^1[^3 %s^1 ] Ai primit ^4 1DGL !",TAG);
                                remove_task(id);
                        }
                        
                        case 1..20:
                        {
                                give_item(id, "weapon_hegrenade");
                                give_item(id, "weapon_flashbang");
                                give_item(id, "weapon_smokegrenade");
                                cs_set_user_bpammo(id, CSW_HEGRENADE, 1);
                                cs_set_user_bpammo(id, CSW_FLASHBANG, 1);
                                cs_set_user_bpammo(id, CSW_SMOKEGRENADE, 1);
                                set_user_health(id, get_user_health(id) + 3);
                                cs_set_weapon_ammo(dgl, 1);
                                ColorChat(id, TEAM_COLOR,"^1[^3 %s^1 ] Ai primit ^4 3HP ^1, ^4 1DGL ^1, ^4 1SG ^1, ^4 1FL ^1, ^4 1HE ^1!",TAG);
                                remove_task(id);
                
                        }
                   
                
                        case 21..40:
                        {
                        
                                give_item(id, "weapon_hegrenade");
                                give_item(id, "weapon_flashbang");
                                give_item(id, "weapon_smokegrenade");
                                cs_set_user_bpammo(id, CSW_HEGRENADE, 2);
                                cs_set_user_bpammo(id, CSW_FLASHBANG, 2);
                                cs_set_user_bpammo(id, CSW_SMOKEGRENADE, 2);
                                
                                cs_set_weapon_ammo(dgl, 2);
                                cs_set_user_bpammo(id, CSW_DEAGLE, 0);
                                
                                set_user_health(id, get_user_health(id) + 5);
                                ColorChat(id, TEAM_COLOR,"^1[^3 %s^1 ] Ai primit ^4 5HP ^1, ^4 2DGL ^1, ^4 2 SG ^1, ^4 2FL ^1, ^4 2HE ^1!",TAG);
                                remove_task(id);
                        }

                        case 41..60:
                        {
                
                                give_item(id, "weapon_hegrenade");
                                give_item(id, "weapon_flashbang");
                                give_item(id, "weapon_smokegrenade");
                                cs_set_user_bpammo(id, CSW_HEGRENADE, 3);
                                cs_set_user_bpammo(id, CSW_FLASHBANG, 3);
                                cs_set_user_bpammo(id, CSW_SMOKEGRENADE, 3);
                        
                                cs_set_weapon_ammo(dgl, 3);
                                cs_set_user_bpammo(id, CSW_DEAGLE, 0);
                        
                                set_user_health(id, get_user_health(id) + 10);
                                ColorChat(id, TEAM_COLOR,"^1[^3 %s^1 ] Ai primit ^4 10HP ^1, ^4 3DGL ^1, ^4 3SG ^1, ^4 3FL ^1, ^4 3HE ^1!",TAG);
                                remove_task(id);
                        }
                
                        case 61..80:
                        {
                        
                                give_item(id, "weapon_hegrenade");
                                give_item(id, "weapon_flashbang");
                                give_item(id, "weapon_smokegrenade");
                                cs_set_user_bpammo(id, CSW_HEGRENADE, 3);
                                cs_set_user_bpammo(id, CSW_FLASHBANG, 4);
                                cs_set_user_bpammo(id, CSW_SMOKEGRENADE, 4);
                                
                                cs_set_weapon_ammo(dgl, 4);
                                
                                cs_set_user_bpammo(id, CSW_DEAGLE, 0);
                                set_user_health(id, get_user_health(id) + 20);
                                ColorChat(id, TEAM_COLOR,"^1[^3 %s^1 ] Ai primit ^4 20HP ^1, ^4 4DGL ^1, ^4 4SG ^1, ^4 4FL ^1, ^4 3HE ^1!",TAG);
                                remove_task(id);
                        }
                        
                        case 81..100:
                        {
                        
                                give_item(id, "weapon_hegrenade");
                                give_item(id, "weapon_flashbang");
                                give_item(id, "weapon_smokegrenade");
                                cs_set_user_bpammo(id, CSW_HEGRENADE, 4);
                                cs_set_user_bpammo(id, CSW_FLASHBANG, 2);
                                cs_set_user_bpammo(id, CSW_SMOKEGRENADE, 5);
                                
                                cs_set_weapon_ammo(dgl, 5);
                                
                                cs_set_user_bpammo(id, CSW_DEAGLE, 0);
                                set_user_health(id, get_user_health(id) + 20);
                                ColorChat(id, TEAM_COLOR,"^1[^3 %s^1 ] Ai primit ^4 20HP ^1, ^4 4DGL ^1, ^4 3SG ^1, ^4 3FL ^1, ^4 3HE ^1!",TAG);
                                remove_task(id);
                        }

			case 101..150:
                        {
                        
                                give_item(id, "weapon_hegrenade");
                                give_item(id, "weapon_flashbang");
                                give_item(id, "weapon_smokegrenade");
                                cs_set_user_bpammo(id, CSW_HEGRENADE, 5);
                                cs_set_user_bpammo(id, CSW_FLASHBANG, 5);
                                cs_set_user_bpammo(id, CSW_SMOKEGRENADE, 5);
                                
                                cs_set_weapon_ammo(dgl, 6);
                                
                                cs_set_user_bpammo(id, CSW_DEAGLE, 0);
                                set_user_health(id, get_user_health(id) + 30);
                                ColorChat(id, TEAM_COLOR,"^1[^3 %s^1 ] Ai primit ^4 30HP ^1, ^4 6DGL ^1, ^4 5SG ^1, ^4 5FL ^1, ^4 5HE ^1!",TAG);
                                remove_task(id);
                        }

			case 151..200:
                        {
                        
                                give_item(id, "weapon_hegrenade");
                                give_item(id, "weapon_flashbang");
                                give_item(id, "weapon_smokegrenade");
                                cs_set_user_bpammo(id, CSW_HEGRENADE, 7);
                                cs_set_user_bpammo(id, CSW_FLASHBANG, 7);
                                cs_set_user_bpammo(id, CSW_SMOKEGRENADE, 7);
                                
                                cs_set_weapon_ammo(dgl, 7);
                                
                                cs_set_user_bpammo(id, CSW_DEAGLE, 0);
                                set_user_health(id, get_user_health(id) + 40);
                                ColorChat(id, TEAM_COLOR,"^1[^3 %s^1 ] Ai primit ^4 40HP ^1, ^4 7DGL ^1, ^4 7SG ^1, ^4 7FL ^1, ^4 7HE ^1!",TAG);
                                remove_task(id);
                        }
                        
                        
 
                }
                        
        }

}

UpdateLevel(id)
{
        if((hnsxp_playerlevel[id] < 101) && (hnsxp_playerxp[id] >= LEVELS[hnsxp_playerlevel[id]]))
        {
		ColorChat(id, TEAM_COLOR,"^1[^3 %s^1 ] Felicitari ai trecut la nivelul urmator !",TAG);            
		ColorChat(id, TEAM_COLOR,"^1[^3 %s^1 ] Felicitari ai trecut la nivelul urmator !",TAG); 
                ColorChat(id, TEAM_COLOR,"^1[^3 %s^1 ] Felicitari ai trecut la nivelul urmator !",TAG); 
		ColorChat(id, TEAM_COLOR,"^1[^3 %s^1 ] Felicitari ai trecut la nivelul urmator !",TAG);
		ColorChat(id, TEAM_COLOR,"^1[^3 %s^1 ] Felicitari ai trecut la nivelul urmator !",TAG); 
                new ret;
                ExecuteForward(xlevel, ret, id);
                while(hnsxp_playerxp[id] >= LEVELS[hnsxp_playerlevel[id]])
                {
                        hnsxp_playerlevel[id]++;
                }
        }
        
}

public hnsxp_spawn(id)
{
        set_task(15.0, "gItem", id);
	new GRAVITYCheck = 800 - 3 * hnsxp_playerlevel[ id ];

	if(is_user_alive(id))
	{
		set_user_gravity( id, float( GRAVITYCheck ) / 800.0 );
	}
        UpdateLevel(id);

}

public plvl(id)
{
        
        ColorChat(id, TEAM_COLOR,"^1[^3 %s^1 ] ^4LVL ^1: ^3%i ^1, ^4XP ^1: ^3%i ^1/ ^3%i ",TAG, hnsxp_playerlevel[id], hnsxp_playerxp[id], LEVELS[hnsxp_playerlevel[id]]);
        return PLUGIN_HANDLED
}

public tlvl(id)
{
        new poj_Name [ 32 ];
        get_user_name(id, poj_Name, 31)
        ColorChat(0, TEAM_COLOR,"^1[^3 %s^1 ] Jucatorul ^3%s ^1are nivelul ^4%i",TAG,poj_Name, hnsxp_playerlevel[id]);
        return PLUGIN_HANDLED
}

public hnsxp_playerdie(iVictim, attacker, iShouldGib) 
{
        
        if( !attacker || attacker == iVictim )
                return;
        
        GiveExp(attacker);
        new ret;
        ExecuteForward(wxp, ret, attacker);
        
        
        UpdateLevel(attacker);
        UpdateLevel(iVictim);


	if(get_pdata_int(iVictim, m_LastHitGroup, 5) == HIT_HEAD)
	{ 
		GiveExp(attacker);
		UpdateLevel(attacker);
	}

        if(is_user_vip(attacker))
        {
		GiveExp(attacker);
        }
}

public client_connect(id)
{
	LoadData(id);             
}
public client_disconnect(id)
{
        SaveData(id);
}
public SaveData(id)
{
        new PlayerName[35];
        get_user_name(id,PlayerName,34);
        
        new vaultkey[64],vaultdata[256];
        format(vaultkey,63,"%s",PlayerName);
        format(vaultdata,255,"%i`i%",hnsxp_playerxp[id],hnsxp_playerlevel[id]);
        nvault_set(g_hnsxp_vault,vaultkey,vaultdata);
        return PLUGIN_CONTINUE;
}
public LoadData(id)
{
        new PlayerName[35];
        get_user_name(id,PlayerName,34);
        
        new vaultkey[64],vaultdata[256];
        format(vaultkey,63,"%s",PlayerName);
        format(vaultdata,255,"%i`%i",hnsxp_playerxp[id],hnsxp_playerlevel[id]);
        nvault_get(g_hnsxp_vault,vaultkey,vaultdata,255);
        
        replace_all(vaultdata, 255, "`", " ");
        
        new playerxp[32], playerlevel[32];
        
        parse(vaultdata, playerxp, 31, playerlevel, 31);
        
        hnsxp_playerxp[id] = str_to_num(playerxp);
        hnsxp_playerlevel[id] = str_to_num(playerlevel);
        
        return PLUGIN_CONTINUE;
}

public t_win(id)
{
        
        new iPlayer [ 32 ], iNum;
        get_players(iPlayer, iNum, "ae", "TERRORIST")
        for ( new i = 0; i < iNum; i++ ) {
                GiveExp(iPlayer [ i ]);
                ColorChat(iPlayer[i], TEAM_COLOR,"^1[^3 %s^1 ] Ai primit ^4XP^1 pentru ca echipa ^4TERO^1 a castigat !",TAG);
                UpdateLevel(iPlayer[i]);
        }
}
ColorChat(id, Color:type, const msg[], {Float,Sql,Result,_}:...)
{
	new message[256];
 
	switch(type)
	{
		case NORMAL: // clients scr_concolor cvar color
		{
			message[0] = 0x01;
		}
		case GREEN: // Green
		{
			message[0] = 0x04;
		}
		default: // White, Red, Blue
		{
			message[0] = 0x03;
		}
	}
	 
	vformat(message[1], 251, msg, 4);
 
	// Make sure message is not longer than 192 character. Will crash the server.
	message[191] = '^0';
 
	new team, ColorChange, index, MSG_Type;
	if(id)
	{
		MSG_Type = MSG_ONE;
		index = id;
	} else {
		index = FindPlayer();
		MSG_Type = MSG_ALL;
	}

	team = get_user_team(index);
	ColorChange = ColorSelection(index, MSG_Type, type);
 

	ShowColorMessage(index, MSG_Type, message);
	if(ColorChange)
	{
		Team_Info(index, MSG_Type, TeamName[team]);
	}
}
 
ShowColorMessage(id, type, message[])
{
	static get_user_msgid_saytext;
	if(!get_user_msgid_saytext)
	{
		get_user_msgid_saytext = get_user_msgid("SayText");
	}
	message_begin(type, get_user_msgid_saytext, _, id);
	write_byte(id)	
	write_string(message);
	message_end();	
}
 
Team_Info(id, type, team[])
{
	static bool:teaminfo_used;
	static get_user_msgid_teaminfo;
	if(!teaminfo_used)
	{
		get_user_msgid_teaminfo = get_user_msgid("TeamInfo");
		teaminfo_used = true;
	}
	message_begin(type, get_user_msgid_teaminfo, _, id);
	write_byte(id);
	write_string(team);
	message_end();
 
	return 1;
}
 
ColorSelection(index, type, Color:Type)
{
	switch(Type)
	{
		case RED:
		{
			return Team_Info(index, type, TeamName[1]);
		}
		case BLUE:
		{
			return Team_Info(index, type, TeamName[2]);
		}
		case GREY:
		{
			return Team_Info(index, type, TeamName[0]);
		}
	}
 
	return 0;
}
 
FindPlayer()
{
	new i = -1;
	static iMaxPlayers;
	if( !iMaxPlayers )
	{
		iMaxPlayers = get_maxplayers( );
	}
	while(i <= iMaxPlayers)
	{
		if(is_user_connected(++i))
			return i;
	}
 
	return -1;
}
