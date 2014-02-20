/* 
	LevelMod @ 2012 by LordOfNothinG

	This project has been started in 2011 now, latest update has been
	made in 2014, i hope you will enjoy my latest version of levelmod

	This software is a free / public software and is illegal to edit
	or sell or made money with him, For more info, plugins please visit:
			

			Thanks Hattrick !
*/

#include <amxmodx>
#include <amxmisc>
#include <fun>
#include <hamsandwich>
#include <nvault>
#include <cstrike>
#include <fakemeta>



/*	()		Leve Mod ConfiGurare !		()		*/




/*	TaGul mesajelor !	*/
#define TAG "Level Mod"


/*	Viteza pe nivel !	*/
#define SPEED_PER_LEVEL		1

/*	DamaGe pe nivel !	*/
#define DAMAGE_PER_LEVEL	10

/*	Hp pe nivel !	*/
#define HEALTH_PER_LEVEL	2

/*	Bani pe nivel !	*/
#define MONEY_PER_LEVEL		1

/*	Gravity pe nivel !	*/
#define GRAVITY_PER_LEVEL	3

/*	Cine are litera "t" primeste xp dublu !		*/
#define VIP_ACCES	ADMIN_LEVEL_H

/*	Cine are acces la amx_xp   	 !		*/
#define ADMIN_ACCES	ADMIN_IMMUNITY




/*	()		----------------------		()	*/




// 	Plugin Info !

new const PLUGIN_NAME[] = "Level Mod";
new const AUTHOR[] = "LordOfNothinG";
new const hnsxp_version[] = "6.4.2";

new levels[150+1] = {
	1,
	2,
	4,
	10,
	15,
	20,
	25,
	30,
	40,
	50,
	60,
	70,
	80,
	90,
	100,
	105,
	110,
	120,
	130,
	140,
	150,
	160,
	170,
	175,
	190,
	200,
	205,
	207,
	215,
	230,
	250,
	255,
	260,
	270,
	285,
	290,
	300,
	310,
	315,
	350, 
	355,
	360,
	363,
	370,
	400,
	405,
	410,
	415,
	420,
	430,
	440,
	445,
	450,
	460,
	470,
	480,
	490,
	500,
	525,
	530,
	536,
	560,
	570,
	586,
	590,
	600,
	610,
	620,
	630,
	635,
	670,
	675,
	682,
	688,
	695,
	700,
	710,
	720,
	725,
	730,
	740,
	748,
	750,
	769,
	800,
	810,
	815,
	830,
	835,
	840,
	850,
	865,
	880,
	900,
	910,
	920,
	930,
	950,
	970,
	1000,
	1050,
	1070,
	1100,
	1150,
	1200,
	1230,
	1250,
	1280,
	1300,
	1350,
	1390,
	1410,
	1450,
	1490,
	1500,
	1530,
	1580,
	1600,
	1610,
	1630,
	1680,
	1690,
	1700,
	1790,
	1850,
	1900,
	1999,
	2000,
	2010,
	2014,
	2050,
	2080,
	2099,
	2150,
	2200,
	2290,
	2300,
	2400,
	2450,
	2510,
	2590,
	2600,
	2650,
	2690,
	2700,
	2800,
	2900,
	3000,
	3500,
	4000,   // Level 150 !
	999999999 // Solve the error !
};
	



#define is_user_vip(%1)		( get_user_flags(%1) & VIP_ACCES )

#define IsPlayer(%1) ( 1 <= %1 <=  g_iMaxPlayers )

new g_iMaxPlayers
new hnsxp_playerxp[33]
new hnsxp_playerlevel[33]
new g_hnsxp_vault
new wxp
new xlevel
new xp_kill_cvar;
new xp_hs_cvar;
new xp_vip_cvar;
new xp_win_cvar;


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
	register_event("DeathMsg", "hnsxp_playerdie", "a");

	xp_kill_cvar = register_cvar("levelmod_kill","1")
	xp_hs_cvar = register_cvar("levelmod_hs","3")
	xp_vip_cvar = register_cvar("levelmod_vip_xp","10")
	xp_win_cvar = register_cvar("levelmod_tero_win","3")

        register_clcmd("say /level","plvl");
        register_clcmd("say /xp","plvl");

        register_clcmd("say_team /xp","plvl");

        register_clcmd("say /lvl","plvl");

        g_hnsxp_vault = nvault_open("levelmod_new_vault");

	register_concmd("amx_xp","cmd_xp",ADMIN_ACCES,"<NUME> <XP>");

       
        register_event("SendAudio", "t_win", "a", "2&%!MRAD_terwin")

        xlevel = CreateMultiForward("PlayerMakeNextLevel", ET_IGNORE, FP_CELL);
        wxp = CreateMultiForward("PlayerIsHookXp", ET_IGNORE, FP_CELL);
	register_forward(FM_ClientUserInfoChanged, "ClientUserInfoChanged") 
	
	g_iMaxPlayers = get_maxplayers ( )
	RegisterHam ( Ham_TakeDamage, "player", "Ham_CheckDamage_Bonus");
	RegisterHam ( Ham_Item_PreFrame, "player", "Ham_CheckSpeed_Bonus", 1);


}

public Player_TakeDamage ( iVictim, iInflictor, iAttacker, Float:fDamage ) {
    
	if ( iInflictor == iAttacker && IsPlayer ( iAttacker ) ) 
	{
    
		SetHamParamFloat ( 4, fDamage + DAMAGE_PER_LEVEL * hnsxp_playerlevel[iAttacker] );
		return HAM_HANDLED;
       	}
    
	return HAM_IGNORED;
    
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

public cmd_xp(id,level,cid)
{
	if(!cmd_access(id,level,cid,3))
		return PLUGIN_HANDLED;
	
	new arg[33], amount[33]
	read_argv(1, arg, charsmax(arg) - 1)
	read_argv(2, amount, charsmax(amount) - 1)
	new target = cmd_target(id, arg, 7)
	new admin_name[35], player_name[35];
	get_user_name(target, player_name, charsmax(player_name) - 1);
	get_user_name(id, admin_name, charsmax(admin_name) - 1);



	new wors = str_to_num(amount)
	
	
	if(!target)
	{
		return 1
	}
	

	hnsxp_playerxp[target] = wors;
	ColorChat(0, TEAM_COLOR, "^1[ ^3%s^1 ] Adminul ^4%s^1 i-a setat ^4%i^1 xp lui ^4%s^1 !",TAG,admin_name,wors,player_name);
	SaveData(target);
	return 0
}
  

public LevelMod_msg(id)
{
	ColorChat(id, TEAM_COLOR, "^1[ ^3%s^1 ] ^4%s^1 ^3(^1R^3)^1 by ^3%s^1 versiunea ^4%s^1 !",TAG,PLUGIN_NAME,AUTHOR,hnsxp_version)
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

public GiveExp(index, value)
{
	hnsxp_playerxp[index] = hnsxp_playerxp[index] + value
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

	new hp = HEALTH_PER_LEVEL * hnsxp_playerlevel[id]
	new money = MONEY_PER_LEVEL * hnsxp_playerlevel[id]

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
                                set_user_health( id, get_user_health( id ) + HEALTH_PER_LEVEL * hnsxp_playerlevel[id] );
				cs_set_user_money( id, cs_get_user_money( id ) + MONEY_PER_LEVEL * hnsxp_playerlevel[id] )
                                cs_set_weapon_ammo(dgl, 1);
                                ColorChat(id, TEAM_COLOR,"^1[^3 %s^1 ] Ai primit ^4 %iHP ^1, ^4 %iMONEY ^1, ^4 1DGL ^1, ^4 1SG ^1, ^4 1FL ^1, ^4 1HE ^1!",TAG,hp,money);
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

                                set_user_health( id, get_user_health( id ) + HEALTH_PER_LEVEL * hnsxp_playerlevel[id] );
				cs_set_user_money( id, cs_get_user_money( id ) + MONEY_PER_LEVEL * hnsxp_playerlevel[id] )
                                
				ColorChat(id, TEAM_COLOR,"^1[^3 %s^1 ] Ai primit ^4 %iHP ^1, ^4 %iMONEY ^1, ^4 2DGL ^1, ^4 2SG ^1, ^4 2FL ^1, ^4 2HE ^1!",TAG,hp,money);
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
                        
                                set_user_health( id, get_user_health( id ) + HEALTH_PER_LEVEL * hnsxp_playerlevel[id] );
				cs_set_user_money( id, cs_get_user_money( id ) + MONEY_PER_LEVEL * hnsxp_playerlevel[id] )

				ColorChat(id, TEAM_COLOR,"^1[^3 %s^1 ] Ai primit ^4 %iHP ^1, ^4 %iMONEY ^1, ^4 3DGL ^1, ^4 3SG ^1, ^4 3FL ^1, ^4 3HE ^1!",TAG,hp,money);
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
                                set_user_health( id, get_user_health( id ) + HEALTH_PER_LEVEL * hnsxp_playerlevel[id] );
				cs_set_user_money( id, cs_get_user_money( id ) + MONEY_PER_LEVEL * hnsxp_playerlevel[id] )
				ColorChat(id, TEAM_COLOR,"^1[^3 %s^1 ] Ai primit ^4 %iHP ^1, ^4 %iMONEY ^1, ^4 4DGL ^1, ^4 4SG ^1, ^4 4FL ^1, ^4 3HE ^1!",TAG,hp,money);
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
                                set_user_health( id, get_user_health( id ) + HEALTH_PER_LEVEL * hnsxp_playerlevel[id] );
				cs_set_user_money( id, cs_get_user_money( id ) + MONEY_PER_LEVEL * hnsxp_playerlevel[id] )
				ColorChat(id, TEAM_COLOR,"^1[^3 %s^1 ] Ai primit ^4 %iHP ^1, ^4 %iMONEY ^1, ^4 5DGL ^1, ^4 5SG ^1, ^4 2FL ^1, ^4 4HE ^1!",TAG,hp,money);
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
                                set_user_health( id, get_user_health( id ) + HEALTH_PER_LEVEL * hnsxp_playerlevel[id] );
				cs_set_user_money( id, cs_get_user_money( id ) + MONEY_PER_LEVEL * hnsxp_playerlevel[id] )
				ColorChat(id, TEAM_COLOR,"^1[^3 %s^1 ] Ai primit ^4 %iHP ^1, ^4 %iMONEY ^1, ^4 6DGL ^1, ^4 5SG ^1, ^4 5FL ^1, ^4 5HE ^1!",TAG,hp,money);
                                remove_task(id);
                        }

                        
 
                }
                        
        }

}

UpdateLevel(id)
{
        if((hnsxp_playerlevel[id] < 151) && (hnsxp_playerxp[id] >= levels[hnsxp_playerlevel[id]]))
        {
		ColorChat(id, TEAM_COLOR,"^1[^3 %s^1 ] Felicitari ai trecut la nivelul urmator !",TAG);            
		ColorChat(id, TEAM_COLOR,"^1[^3 %s^1 ] Felicitari ai trecut la nivelul urmator !",TAG); 
                ColorChat(id, TEAM_COLOR,"^1[^3 %s^1 ] Felicitari ai trecut la nivelul urmator !",TAG); 
		ColorChat(id, TEAM_COLOR,"^1[^3 %s^1 ] Felicitari ai trecut la nivelul urmator !",TAG);
		ColorChat(id, TEAM_COLOR,"^1[^3 %s^1 ] Felicitari ai trecut la nivelul urmator !",TAG); 
                new ret;
                ExecuteForward(xlevel, ret, id);
                while(hnsxp_playerxp[id] >= levels[hnsxp_playerlevel[id]])
                {
                        hnsxp_playerlevel[id]++;
                }
        }
        
}

public hnsxp_spawn(id)
{
        set_task(15.0, "gItem", id);
	new GRAVITYCheck = 800 - GRAVITY_PER_LEVEL * hnsxp_playerlevel[ id ];

	if(is_user_alive(id))
	{
		set_user_gravity( id, float( GRAVITYCheck ) / 800.0 );
	}
        UpdateLevel(id);

	set_task(10.0,"LevelMod_msg", id)

}

public plvl(id)
{
        
        ColorChat(id, TEAM_COLOR,"^1[^3 %s^1 ] ^4LVL ^1: ^3%i ^1, ^4XP ^1: ^3%i ^1/ ^3%i ",TAG, hnsxp_playerlevel[id], hnsxp_playerxp[id], levels[hnsxp_playerlevel[id]]);
        return PLUGIN_HANDLED
}


public hnsxp_playerdie() 
{

	new iVictim = read_data( 2 )
	new attacker = read_data( 1 )
	new headshot = read_data( 3 )
        
        if( !attacker || attacker == iVictim )
                return;
        
        GiveExp(attacker, get_pcvar_num(xp_kill_cvar));
        new ret;
        ExecuteForward(wxp, ret, attacker);
        
        
        UpdateLevel(attacker);
        UpdateLevel(iVictim);


	if(headshot)
	{ 
		GiveExp(attacker, get_pcvar_num(xp_hs_cvar));
		UpdateLevel(attacker);
	}

        if(is_user_vip(attacker))
        {
		GiveExp(attacker, get_pcvar_num(xp_vip_cvar));
		UpdateLevel(attacker);
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
                GiveExp(iPlayer [ i ], get_pcvar_num(xp_win_cvar));
                ColorChat(iPlayer[i], TEAM_COLOR,"^1[^3 %s^1 ] Ai primit^4 %iXP^1 pentru ca echipa ^4TERO^1 a castigat !",TAG,get_pcvar_num(xp_win_cvar));
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



