/* AMX Mod X
* Level Mod Plugin
*
* by LordOfNothing
*
* This file is part of AMX Mod X.
*
*
* This program is free software; you can redistribute it and/or modify it
* under the terms of the GNU General Public License as published by the
* Free Software Foundation; either version 2 of the License, or (at
* your option) any later version.
*
* This program is distributed in the hope that it will be useful, but
* WITHOUT ANY WARRANTY; without even the implied warranty of
* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
* General Public License for more details.
*
* You should have received a copy of the GNU General Public License
* along with this program; if not, write to the Free Software Foundation,
* Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
*
* In addition, as a special exception, the author gives permission to
* link the code of this program with the Half-Life Game Engine ("HL
* Engine") and Modified Game Libraries ("MODs") developed by Valve,
* L.L.C ("Valve"). You must obey the GNU General Public License in all
* respects for all of the code used other than the HL Engine and MODs
* from Valve. If you modify this file, you may extend this exception
* to your version of the file, but you are not obligated to do so. If
* you do not wish to do so, delete this exception statement from your
* version.
*/

#include <amxmodx>
#include <amxmisc>
#include <fun>
#include <hamsandwich>
#include <nvault>
#include <cstrike>
#include <fakemeta>

new const PLUGIN_NAME[] = "Level Mod";
new const hnsxp_version[] = "5.8";
new const LEVELS[151] = {
        
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
	999999999999999999999999999999999 
}
new hnsxp_playerxp[33], hnsxp_playerlevel[33];
new g_hnsxp_vault, wxp, xlevel;

#define is_user_vip(%1)		( get_user_flags(%1) & ADMIN_IMMUNITY )


new Data[64];

new toplevels[33];
new topnames[33][33];


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
        register_plugin(PLUGIN_NAME, hnsxp_version, "LordOfNothing");

        RegisterHam(Ham_Spawn, "player", "hnsxp_spawn", 1);
        RegisterHam(Ham_Killed, "player", "hnsxp_death", 1);


        register_clcmd("say /level","plvl");
        register_clcmd("say /xp","plvl");

        register_clcmd("say /levels","plvls");
        register_clcmd("say_team /level","plvl");
        register_clcmd("say_team /xp","plvl");

        register_clcmd("say /lvl","tlvl");
        g_hnsxp_vault = nvault_open("levelmod_vault");
       

        register_event("SendAudio", "t_win", "a", "2&%!MRAD_terwin")

        xlevel = CreateMultiForward("PlayerMakeNextLevel", ET_IGNORE, FP_CELL);
        wxp = CreateMultiForward("PlayerIsHookXp", ET_IGNORE, FP_CELL);
        register_forward(FM_ClientUserInfoChanged, "ClientUserInfoChanged")
        
        register_clcmd("say /toplevel","sayTopLevel");
        register_clcmd("say_team /toplevel","sayTopLevel");
        register_concmd("amx_resetleveltop","concmdReset_Top");
        
        get_datadir(Data, 63);
        read_top();

	register_concmd("amx_xp", "xp_cmd", ADMIN_CVAR, "amx_xp <NICK> <NUMARUL DE XP>")
	register_concmd("amx_givexp", "givexp_cmd", ADMIN_CVAR, "amx_givexp <NICK> <NUMARUL DE XP>")
	register_concmd("amx_takexp", "takexp_cmd", ADMIN_CVAR, "amx_takexp <NICK> <NUMARUL DE XP>")
	register_concmd("amx_level", "level_cmd", ADMIN_CVAR, "amx_level <NICK> <NUMARUL DE LEVEL>")
	register_concmd("amx_takelevel", "takelevel_cmd", ADMIN_CVAR, "amx_takelevel <NICK> <NUMARUL DE LEVEL>")
	register_concmd("amx_givelevel", "givelevel_cmd", ADMIN_CVAR, "amx_givelevel <NICK> <NUMARUL DE LEVEL>")
}

public xp_cmd(id,level,cid)
{
	if(!cmd_access(id,level,cid,3))
		return PLUGIN_HANDLED;
	
	new arg[33], amount[220]
	read_argv(1, arg, 32)
	new target = cmd_target(id, arg, 7)
	read_argv(2, amount, charsmax(amount) - 1)
	
	new exp = str_to_num(amount)
	
	if(!target)
	{
		return 1
	}
	
	hnsxp_playerxp[target] = exp
	checkandupdatetop(target,hnsxp_playerlevel[target])
	UpdateLevel(target)
	return 0
}


public givexp_cmd(id,level,cid)
{
	if(!cmd_access(id,level,cid,3))
		return PLUGIN_HANDLED;
	
	new arg[33], amount[220]
	read_argv(1, arg, 32)
	new target = cmd_target(id, arg, 7)
	read_argv(2, amount, charsmax(amount) - 1)
	
	new exp = str_to_num(amount)
	
	if(!target)
	{
		return 1
	}
	
	hnsxp_playerxp[target] = hnsxp_playerxp[target] + exp
	checkandupdatetop(target,hnsxp_playerlevel[target])
	UpdateLevel(target)
	return 0
}


public takexp_cmd(id,level,cid)
{
	if(!cmd_access(id,level,cid,3))
		return PLUGIN_HANDLED;
	
	new arg[33], amount[220]
	read_argv(1, arg, 32)
	new target = cmd_target(id, arg, 7)
	read_argv(2, amount, charsmax(amount) - 1)

	new exp = str_to_num(amount)
	
	if(!target)
	{
		return 1
	}
	
	hnsxp_playerxp[target] = hnsxp_playerxp[target] - exp
	checkandupdatetop(target,hnsxp_playerlevel[target])
	return 0
}

public level_cmd(id,level,cid)
{
	if(!cmd_access(id,level,cid,3))
		return PLUGIN_HANDLED;
	
	new arg[33], amount[220]
	read_argv(1, arg, 32)
	new target = cmd_target(id, arg, 7)
	read_argv(2, amount, charsmax(amount) - 1)
	
	new exp = str_to_num(amount)
	
	if(!target)
	{
		return 1
	}
	
	hnsxp_playerlevel[target] = exp
	checkandupdatetop(target,hnsxp_playerlevel[target])
	UpdateLevel(target)
	return 0
}


public takelevel_cmd(id,level,cid)
{
	if(!cmd_access(id,level,cid,3))
		return PLUGIN_HANDLED;
	
	new arg[33], amount[220]
	read_argv(1, arg, 32)
	new target = cmd_target(id, arg, 7)
	read_argv(2, amount, charsmax(amount) - 1)
	
	new exp = str_to_num(amount)
	
	if(!target)
	{
		return 1
	}
	
	hnsxp_playerlevel[target] = hnsxp_playerlevel[target] - exp
	checkandupdatetop(target,hnsxp_playerlevel[target])
	return 0
}


public givelevel_cmd(id,level,cid)
{
	if(!cmd_access(id,level,cid,3))
		return PLUGIN_HANDLED;
	
	new arg[33], amount[220]
	read_argv(1, arg, 32)
	new target = cmd_target(id, arg, 7)
	read_argv(2, amount, charsmax(amount) - 1)
	
	new exp = str_to_num(amount)
	
	if(!target)
	{
		return 1
	}
	
	hnsxp_playerlevel[target] = hnsxp_playerlevel[target] - exp
	checkandupdatetop(target,hnsxp_playerlevel[target])
	UpdateLevel(target)
	return 0
}

public save_top() {
        new path[128];
        formatex(path, 127, "%s/LevelTop.dat", Data);
        if( file_exists(path) ) {
                delete_file(path);
        }
        new Buffer[256];
        new f = fopen(path, "at");
        for(new i = 0; i < 15; i++)
        {
                formatex(Buffer, 255, "^"%s^" ^"%d^"^n",topnames[i],toplevels[i] );
                fputs(f, Buffer);
        }
        fclose(f);
}
public concmdReset_Top(id) {
        
        if( !(get_user_flags(id) & read_flags("abcdefghijklmnopqrstu"))) {
                       return PLUGIN_HANDLED;
        }
        new path[128];
        formatex(path, 127, "%s/LevelTop.dat", Data);
        if( file_exists(path) ) {
                delete_file(path);
        }        
        static info_none[33];
        info_none = "";
        for( new i = 0; i < 15; i++ ) {
                formatex(topnames[i], 31, info_none);
                toplevels[i]= 0;
        }
        save_top();
        new aname[32];
        get_user_name(id, aname, 31);
        ColorChat(0, TEAM_COLOR,"^1[^3 Level-Mod^1 ] Adminul ^4%s^1 a resetat top level!", aname);
        return PLUGIN_CONTINUE;
}
public checkandupdatetop(id, levels) {        

        new name[32];
        get_user_name(id, name, 31);
        for (new i = 0; i < 15; i++)
        {
                if( levels > toplevels[i] )
                {
                        new pos = i;        
                        while( !equal(topnames[pos],name) && pos < 15 )
                        {
                                pos++;
                        }
                        
                        for (new j = pos; j > i; j--)
                        {
                                formatex(topnames[j], 31, topnames[j-1]);
                                toplevels[j] = toplevels[j-1];
                                
                        }
                        formatex(topnames[i], 31, name);
                        
                        toplevels[i]= levels;
                        
                        ColorChat(0, TEAM_COLOR,"^1[^3 Level-Mod^1 ] Jucatorul ^4%s^1 a intrat pe locul ^4%i^1 in top level !", name,(i+1));
                        if(i+1 == 1) {
                                client_cmd(0, "spk vox/doop");
                        } else {
                                client_cmd(0, "spk buttons/bell1");
                        }
                        save_top();
                        break;
                }
                else if( equal(topnames[i], name))
                break;        
        }
}
public read_top() {
        new Buffer[256],path[128];
        formatex(path, 127, "%s/LevelTop.dat", Data);
        
        new f = fopen(path, "rt" );
        new i = 0;
        while( !feof(f) && i < 15+1)
        {
                fgets(f, Buffer, 255);
                new lvls[25];
                parse(Buffer, topnames[i], 31, lvls, 24);
                toplevels[i]= str_to_num(lvls);
                
                i++;
        }
        fclose(f);
}
public sayTopLevel(id) {	
	static buffer[2368], name[131], len, i;
	len = formatex(buffer, 2047, "<body bgcolor=#FFFFFF><table width=100%% cellpadding=2 cellspacing=0 border=0>");
	len += format(buffer[len], 2367-len, "<tr align=center bgcolor=#52697B><th width=10%% > # <th width=45%%> Nume <th width=45%%>Level");
	for( i = 0; i < 15; i++ ) {		
		if( toplevels[i] == 0) {
			len += formatex(buffer[len], 2047-len, "<tr align=center%s><td> %d <td> %s <td> %s",((i%2)==0) ? "" : " bgcolor=#A4BED6", (i+1), "-", "-");
			//i = NTOP
		}
		else {
			name = topnames[i];
			while( containi(name, "<") != -1 )
				replace(name, 129, "<", "&lt;");
			while( containi(name, ">") != -1 )
				replace(name, 129, ">", "&gt;");
			len += formatex(buffer[len], 2047-len, "<tr align=center%s><td> %d <td> %s <td> %d",((i%2)==0) ? "" : " bgcolor=#A4BED6", (i+1), name,toplevels[i]);
		}
	}
	len += format(buffer[len], 2367-len, "</table>");
	len += formatex(buffer[len], 2367-len, "<tr align=bottom font-size:11px><Center><br><br><br><br>by BACON</body>");
	static strin[20];
	format(strin,33, "Top Level");
	show_motd(id, buffer, strin);
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
			hnsxp_playerxp[index] = hnsxp_playerxp[index] + 15000;
		}
		case 21..30:
		{
			hnsxp_playerxp[index] = hnsxp_playerxp[index] + 25040;
		}

		case 31..40:
		{
			hnsxp_playerxp[index] = hnsxp_playerxp[index] + 65030;
		}

		case 41..50:
		{
			hnsxp_playerxp[index] = hnsxp_playerxp[index] + 302060;
		}

		case 51..80:
		{
			hnsxp_playerxp[index] = hnsxp_playerxp[index] + 905000;
		}

		case 81..100:
		{
			hnsxp_playerxp[index] = hnsxp_playerxp[index] + 1800500;
		}

		case 101..150:
		{
			hnsxp_playerxp[index] = hnsxp_playerxp[index] + 900050600;
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
                        ColorChat(id, TEAM_COLOR,"^1[^3 Level-Mod^1 ] Pe acest server nu este permisa schimbarea numelui !");
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

public _set_user_xp(plugin, value)
{
	new id = get_param(1)

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


public _set_user_level(plugin, valuex)
{
	new id = get_param(1)

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
                                give_item(id, "weapon_smokegrenade");
                                set_user_health(id, get_user_health(id) + 3);
                                cs_set_weapon_ammo(dgl, 1);
                                ColorChat(id, TEAM_COLOR,"^1[^3 Level-Mod^1 ] Ai primit ^4 3HP ^1, ^4 1DGL ^1, ^4 1SG ^1 !");
                                remove_task(id);
                        }
                        
                        case 1..10:
                        {
                                give_item(id, "weapon_hegrenade");
                                give_item(id, "weapon_flashbang");
                                give_item(id, "weapon_smokegrenade");
                                cs_set_user_bpammo(id, CSW_HEGRENADE, 1);
                                cs_set_user_bpammo(id, CSW_FLASHBANG, 1);
                                cs_set_user_bpammo(id, CSW_SMOKEGRENADE, 1);
                                set_user_health(id, get_user_health(id) + 5);
                                cs_set_weapon_ammo(dgl, 1);
                                ColorChat(id, TEAM_COLOR,"^1[^3 Level-Mod^1 ] Ai primit ^4 5HP ^1, ^4 1DGL ^1, ^4 1SG ^1, ^4 1FL ^1, ^4 1HE ^1!");
                                remove_task(id);
                
                        }
                
                        case 11..20:
                        {
                                give_item(id, "weapon_hegrenade");
                                give_item(id, "weapon_flashbang");
                                give_item(id, "weapon_smokegrenade");
                                cs_set_user_bpammo(id, CSW_HEGRENADE, 1);
                                cs_set_user_bpammo(id, CSW_FLASHBANG, 1);
                                cs_set_user_bpammo(id, CSW_SMOKEGRENADE, 1);
                        
                                cs_set_weapon_ammo(dgl, 1);
                                cs_set_user_bpammo(id, CSW_DEAGLE, 0);
                                set_user_health(id, get_user_health(id) + 10);
                                ColorChat(id, TEAM_COLOR,"^1[^3 Level-Mod^1 ] Ai primit ^4 10HP ^1, ^4 1DGL ^1, ^4 1SG ^1, ^41 FL ^1, ^4 1HE ^1!");
                                remove_task(id);
                
                        }
                
                        case 21..30:
                        {
                        
                                give_item(id, "weapon_hegrenade");
                                give_item(id, "weapon_flashbang");
                                give_item(id, "weapon_smokegrenade");
                                cs_set_user_bpammo(id, CSW_HEGRENADE, 2);
                                cs_set_user_bpammo(id, CSW_FLASHBANG, 2);
                                cs_set_user_bpammo(id, CSW_SMOKEGRENADE, 2);
                                
                                cs_set_weapon_ammo(dgl, 2);
                                cs_set_user_bpammo(id, CSW_DEAGLE, 0);
                                
                                set_user_health(id, get_user_health(id) + 10);
                                ColorChat(id, TEAM_COLOR,"^1[^3 Level-Mod^1 ] Ai primit ^4 10HP ^1, ^4 2DGL ^1, ^4 2SG ^1, ^42FL ^1, ^42HE ^1!");
                                remove_task(id);
                        }

                        case 31..40:
                        {
                
                                give_item(id, "weapon_hegrenade");
                                give_item(id, "weapon_flashbang");
                                give_item(id, "weapon_smokegrenade");
                                cs_set_user_bpammo(id, CSW_HEGRENADE, 2);
                                cs_set_user_bpammo(id, CSW_FLASHBANG, 2);
                                cs_set_user_bpammo(id, CSW_SMOKEGRENADE, 2);
                        
                                cs_set_weapon_ammo(dgl, 3);
                                cs_set_user_bpammo(id, CSW_DEAGLE, 0);
                        
                                set_user_health(id, get_user_health(id) + 10);
                                ColorChat(id, TEAM_COLOR,"^1[^3 Level-Mod^1 ] Ai primit ^4 10HP ^1, ^4 3DGL ^1, ^4 2SG ^1, ^4 2FL ^1, ^4 2HE ^1!");
                                remove_task(id);
                        }
                
                        case 41..50:
                        {
                        
                                give_item(id, "weapon_hegrenade");
                                give_item(id, "weapon_flashbang");
                                give_item(id, "weapon_smokegrenade");
                                cs_set_user_bpammo(id, CSW_HEGRENADE, 3);
                                cs_set_user_bpammo(id, CSW_FLASHBANG, 3);
                                cs_set_user_bpammo(id, CSW_SMOKEGRENADE, 3);
                                
                                cs_set_weapon_ammo(dgl, 4);
                                
                                cs_set_user_bpammo(id, CSW_DEAGLE, 0);
                                set_user_health(id, get_user_health(id) + 20);
                                ColorChat(id, TEAM_COLOR,"^1[^3 Level-Mod^1 ] Ai primit ^4 20HP ^1, ^4 4DGL ^1, ^4 3SG ^1, ^4 3FL ^1, ^4 3HE ^1!");
                                remove_task(id);
                        }
                        
                        case 51..60:
                        {
                        
                                give_item(id, "weapon_hegrenade");
                                give_item(id, "weapon_flashbang");
                                give_item(id, "weapon_smokegrenade");
                                cs_set_user_bpammo(id, CSW_HEGRENADE, 3);
                                cs_set_user_bpammo(id, CSW_FLASHBANG, 3);
                                cs_set_user_bpammo(id, CSW_SMOKEGRENADE, 3);
                                
                                cs_set_weapon_ammo(dgl, 4);
                                
                                cs_set_user_bpammo(id, CSW_DEAGLE, 0);
                                set_user_health(id, get_user_health(id) + 20);
                                ColorChat(id, TEAM_COLOR,"^1[^3 Level-Mod^1 ] Ai primit ^4 20HP ^1, ^4 4DGL ^1, ^4 3SG ^1, ^4 3FL ^1, ^4 3HE ^1!");
                                remove_task(id);
                        }
                        case 61..70:
                        {
                        
                                give_item(id, "weapon_hegrenade");
                                give_item(id, "weapon_flashbang");
                                give_item(id, "weapon_smokegrenade");
                                cs_set_user_bpammo(id, CSW_HEGRENADE, 4);
                                cs_set_user_bpammo(id, CSW_FLASHBANG, 4);
                                cs_set_user_bpammo(id, CSW_SMOKEGRENADE, 4);
                                
                                cs_set_weapon_ammo(dgl, 4);
                                
                                cs_set_user_bpammo(id, CSW_DEAGLE, 0);
                                set_user_health(id, get_user_health(id) + 25);
                                ColorChat(id, TEAM_COLOR,"^1[^3 Level-Mod^1 ] Ai primit ^4 25HP ^1, ^4 4DGL ^1, ^4 4SG ^1, ^4 4FL ^1, ^4 4HE ^1!");
                                remove_task(id);
                        }
                        case 71..80:
                        {
                        
                                give_item(id, "weapon_hegrenade");
                                give_item(id, "weapon_flashbang");
                                give_item(id, "weapon_smokegrenade");
                                cs_set_user_bpammo(id, CSW_HEGRENADE, 4);
                                cs_set_user_bpammo(id, CSW_FLASHBANG, 4);
                                cs_set_user_bpammo(id, CSW_SMOKEGRENADE, 4);
                                
                                cs_set_weapon_ammo(dgl, 5);
                                
                                cs_set_user_bpammo(id, CSW_DEAGLE, 0);
                                set_user_health(id, get_user_health(id) + 30);
                                ColorChat(id, TEAM_COLOR,"^1[^3 Level-Mod^1 ] Ai primit ^4 30HP ^1, ^4 5DGL ^1, ^4 4SG ^1, ^4 4FL ^1, ^4 4HE ^1!");
                                remove_task(id);
                        }
                        case 81..90:
                        {
                        
                                give_item(id, "weapon_hegrenade");
                                give_item(id, "weapon_flashbang");
                                give_item(id, "weapon_smokegrenade");
                                cs_set_user_bpammo(id, CSW_HEGRENADE, 4);
                                cs_set_user_bpammo(id, CSW_FLASHBANG, 4);
                                cs_set_user_bpammo(id, CSW_SMOKEGRENADE, 4);
                                
                                cs_set_weapon_ammo(dgl, 6);
                                
                                cs_set_user_bpammo(id, CSW_DEAGLE, 0);
                                set_user_health(id, get_user_health(id) + 30);
                                ColorChat(id, TEAM_COLOR,"^1[^3 Level-Mod^1 ] Ai primit ^4 30HP ^1, ^4 6DGL ^1, ^4 4SG ^1, ^4 4FL ^1, ^4 4HE ^1!");
                                remove_task(id);
                        }
                        
                        case 91..100:
                        {
                        
                                give_item(id, "weapon_hegrenade");
                                give_item(id, "weapon_flashbang");
                                give_item(id, "weapon_smokegrenade");
                                cs_set_user_bpammo(id, CSW_HEGRENADE, 5);
                                cs_set_user_bpammo(id, CSW_FLASHBANG, 5);
                                cs_set_user_bpammo(id, CSW_SMOKEGRENADE, 5);

                                cs_set_weapon_ammo(dgl, 6);
                                
                                cs_set_user_bpammo(id, CSW_DEAGLE, 0);
                                set_user_health(id, get_user_health(id) + 50);
                                ColorChat(id, TEAM_COLOR,"^1[^3 Level-Mod^1 ] Ai primit ^4 50HP ^1, ^4 6DGL ^1, ^4 5SG ^1, ^4 5FL ^1, ^4 5HE ^1!");
                                remove_task(id);
                        }
                        
                        case 101..120:
                        {
                        
                                give_item(id, "weapon_hegrenade");
                                give_item(id, "weapon_flashbang");
                                give_item(id, "weapon_smokegrenade");
                                cs_set_user_bpammo(id, CSW_HEGRENADE, 6);
                                cs_set_user_bpammo(id, CSW_FLASHBANG, 6);
                                cs_set_user_bpammo(id, CSW_SMOKEGRENADE, 6);

                                cs_set_weapon_ammo(dgl, 6);
                                
                                cs_set_user_bpammo(id, CSW_DEAGLE, 0);
                                set_user_health(id, get_user_health(id) + 100);
                                ColorChat(id, TEAM_COLOR,"^1[^3 Level-Mod^1 ] Ai primit ^4 100HP ^1, ^4 6DGL ^1, ^4 6SG ^1, ^4 6FL ^1, ^4 6HE ^1!");
                                remove_task(id);
                        }
                        case 121..150:
                        {
                        
                                give_item(id, "weapon_hegrenade");
                                give_item(id, "weapon_flashbang");
                                give_item(id, "weapon_smokegrenade");
                                cs_set_user_bpammo(id, CSW_HEGRENADE, 7);
                                cs_set_user_bpammo(id, CSW_FLASHBANG, 7);
                                cs_set_user_bpammo(id, CSW_SMOKEGRENADE, 7);

                                cs_set_weapon_ammo(dgl, 7);
                                
                                cs_set_user_bpammo(id, CSW_DEAGLE, 0);
                                set_user_health(id, get_user_health(id) + 150);
                                ColorChat(id, TEAM_COLOR,"^1[^3 Level-Mod^1 ] Ai primit ^4 150HP ^1, ^4 7DGL ^1, ^4 7SG ^1, ^4 7FL ^1, ^4 7HE ^1!");
                                remove_task(id);
                        }
 
                }
                        
        }

}

UpdateLevel(id)
{
        if((hnsxp_playerlevel[id] < 101) && (hnsxp_playerxp[id] >= LEVELS[hnsxp_playerlevel[id]]))
        {
		ColorChat(id, TEAM_COLOR,"^1[^3 Level-Mod^1 ] Felicitari ai trecut la nivelul urmator !");            
		ColorChat(id, TEAM_COLOR,"^1[^3 Level-Mod^1 ] Felicitari ai trecut la nivelul urmator !"); 
                ColorChat(id, TEAM_COLOR,"^1[^3 Level-Mod^1 ] Felicitari ai trecut la nivelul urmator !"); 
		ColorChat(id, TEAM_COLOR,"^1[^3 Level-Mod^1 ] Felicitari ai trecut la nivelul urmator !"); 
		ColorChat(id, TEAM_COLOR,"^1[^3 Level-Mod^1 ] Felicitari ai trecut la nivelul urmator !"); 
                new ret;
                ExecuteForward(xlevel, ret, id);
                while(hnsxp_playerxp[id] >= LEVELS[hnsxp_playerlevel[id]])
                {
                        hnsxp_playerlevel[id] += 1;
                }
        }
        
}

public hnsxp_spawn(id)
{
        set_task(15.0, "gItem", id);
        UpdateLevel(id);
        checkandupdatetop(id,hnsxp_playerlevel[id]);
}

public plvl(id)
{
        
        ColorChat(id, TEAM_COLOR,"^1[^3 Level-Mod^1 ] ^4LVL ^1: ^3%i ^1, ^4XP ^1: ^3%i ^1/ ^3%i ", hnsxp_playerlevel[id], hnsxp_playerxp[id], LEVELS[hnsxp_playerlevel[id]]);
        return PLUGIN_HANDLED
}

public plvls(id)
{
        new players[32], playersnum, name[40], motd[1024], len;
        
        len = formatex(motd, charsmax(motd), "<html> <center> <font color=red> <b>LEVEL NUME XP <br ></font> </b> <body bgcolor=black></center> ");
        get_players(players, playersnum);
        
        for ( new i = 0 ; i < playersnum ; i++ ) {
                get_user_name(players[i], name, charsmax(name));
                len += formatex(motd[len], charsmax(motd) - len, "<center> <br><font color=red> <b> [%i] %s: %i</font>  </center> ",hnsxp_playerlevel[players[i]], name, hnsxp_playerxp[players[i]]);
        }
        
        formatex(motd[len], charsmax(motd) - len, "</html>");
        show_motd(id, motd);
        return PLUGIN_HANDLED
        
        
}
public tlvl(id)
{
        new poj_Name [ 32 ];
        get_user_name(id, poj_Name, 31)
        ColorChat(0, TEAM_COLOR,"^1[^3 Level-Mod^1 ] Jucatorul ^3%s ^1are nivelul ^4%i",poj_Name, hnsxp_playerlevel[id]);
        return PLUGIN_HANDLED
}

public hnsxp_death( iVictim, attacker, shouldgib )
{
        
        if( !attacker || attacker == iVictim )
                return;
        
        GiveExp(attacker);
        new ret;
        ExecuteForward(wxp, ret, attacker);
        
        
        UpdateLevel(attacker);
        UpdateLevel(iVictim);
        checkandupdatetop(iVictim,hnsxp_playerlevel[iVictim]);
        checkandupdatetop(attacker,hnsxp_playerlevel[attacker]);

        if(is_user_vip(attacker))
        {
		GiveExp(attacker);
        }
}

public client_connect(id)
{

	LoadData(id);
	checkandupdatetop(id,hnsxp_playerlevel[id])               
}
public client_disconnect(id)
{

        SaveData(id);
        checkandupdatetop(id,hnsxp_playerlevel[id])
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
                ColorChat(iPlayer[i], TEAM_COLOR,"^1[^3 Level-Mod^1 ] Ai primit ^4XP^1 pentru ca echipa ^4TERO^1 a castigat !");
                UpdateLevel(iPlayer[i]);
                checkandupdatetop(iPlayer[i],hnsxp_playerlevel[iPlayer[i]])
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

