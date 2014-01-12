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
new const hnsxp_version[] = "5.3";
new const LEVELS[100] = {
        
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
        20000000000 // 100
        
        
}
new hnsxp_playerxp[33], hnsxp_playerlevel[33];
new hnsxp_kill, hnsxp_savexp, g_hnsxp_vault, tero_win, vip_enable, vip_xp, xlevel, wxp;


new Data[64];

new toplevels[33];
new topnames[33][33];

public plugin_init()
{
        register_plugin(PLUGIN_NAME, hnsxp_version, "LordOfNothing");

        RegisterHam(Ham_Spawn, "player", "hnsxp_spawn", 1);
        RegisterHam(Ham_Killed, "player", "hnsxp_death", 1);

        hnsxp_savexp = register_cvar("hnsxp_savexp","1");
        hnsxp_kill = register_cvar("hnsxp_kill", "1000");
        tero_win = register_cvar("hnsxp_terowin_xp","1500");
        vip_enable = register_cvar("hnsxp_vip_enable","1");
        vip_xp = register_cvar("hnsxp_vip_xp","100000");


        register_clcmd("say /level","plvl");
        register_clcmd("say /xp","plvl");

        register_clcmd("say /levels","plvls");
        register_clcmd("say_team /level","plvl");
        register_clcmd("say_team /xp","plvl");

        register_clcmd("say /lvl","tlvl");
        g_hnsxp_vault = nvault_open("deathrun_xp");
        
        register_concmd("amx_xp", "cmd_set_xp", ADMIN_CVAR, "<target> <amount>");
        register_concmd("amx_level", "cmd_set_level", ADMIN_CVAR, "<target> <amount>");

        register_event("SendAudio", "t_win", "a", "2&%!MRAD_terwin")

        xlevel = CreateMultiForward("PlayerMakeNextLevel", ET_IGNORE, FP_CELL);
        wxp = CreateMultiForward("PlayerIsHookXp", ET_IGNORE, FP_CELL);
        register_forward(FM_ClientUserInfoChanged, "ClientUserInfoChanged")
        
        register_clcmd("say /toplevel","sayTopLevel");
        register_clcmd("say_team /toplevel","sayTopLevel");
	register_concmd("amx_resetleveltop","concmdReset_Top");
	
	get_datadir(Data, 63);
	read_top();

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
	MesajColorat(0, "!normal[ !echipaLevel Mod !normal] Adminul !echipa%s!normal a resetat top level!", aname);
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
			
			MesajColorat(id, "[ !echipaLevel Mod !normal] Jucatorul !echipa%s !normaleste pe locul !echipa%i", name,(i+1));
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
	len += formatex(buffer[len], 2367-len, "<tr align=bottom font-size:11px><Center><br><br><br><br>DeathRun TopLevel by sPuf ?</body>");
	static strin[20];
	format(strin,33, "Top Level");
	show_motd(id, buffer, strin);
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
                        MesajColorat(id, "!normal[!echipaLevel Mod!normal] Pe acest server nu este permisa schimbarea numelui !");
                        return FMRES_HANDLED
                }
        }
        return FMRES_IGNORED
}

public plugin_natives()
{
        register_native("get_user_xp","_get_user_xp");
        register_native("get_user_level","_get_user_level");
}

public _get_user_xp(plugin, params)
{
        return hnsxp_playerxp[get_param(1)];
}

public _get_user_level(plugin, params)
{
        return hnsxp_playerlevel[get_param(1)];
}

public gItem(id)
{

        new dgl = give_item(id, "weapon_deagle");

        if(is_user_alive(id))
        {
                switch(hnsxp_playerlevel[id])
                {
                        case 1..10:
                        {
                                give_item(id, "weapon_hegrenade");
                                give_item(id, "weapon_flashbang");
                                give_item(id, "weapon_smokegrenade");
                                cs_set_user_bpammo(id, CSW_HEGRENADE, 3);
                                cs_set_user_bpammo(id, CSW_FLASHBANG, 3);
                                cs_set_user_bpammo(id, CSW_SMOKEGRENADE, 3);
                                set_user_health(id, get_user_health(id) + 5);
                                remove_task(id);
                
                        }
                
                        case 11..20:
                        {
                                give_item(id, "weapon_hegrenade");
                                give_item(id, "weapon_flashbang");
                                give_item(id, "weapon_smokegrenade");
                                cs_set_user_bpammo(id, CSW_HEGRENADE, 3);
                                cs_set_user_bpammo(id, CSW_FLASHBANG, 3);
                                cs_set_user_bpammo(id, CSW_SMOKEGRENADE, 3);
                        
                                give_item(id, "weapon_deagle");
                                cs_set_weapon_ammo(dgl, 1);
                                cs_set_user_bpammo(id, CSW_DEAGLE, 0);
                                set_user_health(id, get_user_health(id) + 15);
                                remove_task(id);
                
                        }
                
                        case 21..30:
                        {
                        
                                give_item(id, "weapon_hegrenade");
                                give_item(id, "weapon_flashbang");
                                give_item(id, "weapon_smokegrenade");
                                cs_set_user_bpammo(id, CSW_HEGRENADE, 3);
                                cs_set_user_bpammo(id, CSW_FLASHBANG, 3);
                                cs_set_user_bpammo(id, CSW_SMOKEGRENADE, 3);
                                
                                give_item(id, "weapon_deagle");
                                cs_set_weapon_ammo(dgl, 2);
                                cs_set_user_bpammo(id, CSW_DEAGLE, 0);
                                
                                set_user_health(id, get_user_health(id) + 20);
                                remove_task(id);
                        }

                        case 31..40:
                        {
                
                                give_item(id, "weapon_hegrenade");
                                give_item(id, "weapon_flashbang");
                                give_item(id, "weapon_smokegrenade");
                                cs_set_user_bpammo(id, CSW_HEGRENADE, 3);
                                cs_set_user_bpammo(id, CSW_FLASHBANG, 3);
                                cs_set_user_bpammo(id, CSW_SMOKEGRENADE, 3);
                        
                                give_item(id, "weapon_deagle");
                                cs_set_weapon_ammo(dgl, 3);
                                cs_set_user_bpammo(id, CSW_DEAGLE, 0);
                        
                                set_user_health(id, get_user_health(id) + 25);
                                remove_task(id);
                        }
                
                        case 41..50:
                        {
                        
                                give_item(id, "weapon_hegrenade");
                                give_item(id, "weapon_flashbang");
                                give_item(id, "weapon_smokegrenade");
                                cs_set_user_bpammo(id, CSW_HEGRENADE, 4);
                                cs_set_user_bpammo(id, CSW_FLASHBANG, 4);
                                cs_set_user_bpammo(id, CSW_SMOKEGRENADE, 4);
                                
                                give_item(id, "weapon_deagle");
                                cs_set_weapon_ammo(dgl, 4);
                                
                                cs_set_user_bpammo(id, CSW_DEAGLE, 0);
                                set_user_health(id, get_user_health(id) + 35);
                                remove_task(id);
                        }
                        
                        case 51..60:
                        {
                        
                                give_item(id, "weapon_hegrenade");
                                give_item(id, "weapon_flashbang");
                                give_item(id, "weapon_smokegrenade");
                                cs_set_user_bpammo(id, CSW_HEGRENADE, 4);
                                cs_set_user_bpammo(id, CSW_FLASHBANG, 4);
                                cs_set_user_bpammo(id, CSW_SMOKEGRENADE, 4);
                                
                                give_item(id, "weapon_deagle");
                                cs_set_weapon_ammo(dgl, 4);
                                
                                cs_set_user_bpammo(id, CSW_DEAGLE, 0);
                                set_user_health(id, get_user_health(id) + 45);
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
                                
                                give_item(id, "weapon_deagle");
                                cs_set_weapon_ammo(dgl, 4);
                                
                                cs_set_user_bpammo(id, CSW_DEAGLE, 0);
                                set_user_health(id, get_user_health(id) + 100);
                                remove_task(id);
                        }
                        case 71..80:
                        {
                        
                                give_item(id, "weapon_hegrenade");
                                give_item(id, "weapon_flashbang");
                                give_item(id, "weapon_smokegrenade");
                                cs_set_user_bpammo(id, CSW_HEGRENADE, 5);
                                cs_set_user_bpammo(id, CSW_FLASHBANG, 5);
                                cs_set_user_bpammo(id, CSW_SMOKEGRENADE, 5);
                                
                                give_item(id, "weapon_deagle");
                                cs_set_weapon_ammo(dgl, 5);
                                
                                cs_set_user_bpammo(id, CSW_DEAGLE, 0);
                                set_user_health(id, get_user_health(id) + 150);
                                remove_task(id);
                        }
                        case 81..90:
                        {
                        
                                give_item(id, "weapon_hegrenade");
                                give_item(id, "weapon_flashbang");
                                give_item(id, "weapon_smokegrenade");
                                cs_set_user_bpammo(id, CSW_HEGRENADE, 5);
                                cs_set_user_bpammo(id, CSW_FLASHBANG, 5);
                                cs_set_user_bpammo(id, CSW_SMOKEGRENADE, 5);
                                
                                give_item(id, "weapon_deagle");
                                cs_set_weapon_ammo(dgl, 6);
                                
                                cs_set_user_bpammo(id, CSW_DEAGLE, 0);
                                set_user_health(id, get_user_health(id) + 300);
                                remove_task(id);
                        }
                        
                        case 91..100:
                        {
                        
                                give_item(id, "weapon_hegrenade");
                                give_item(id, "weapon_flashbang");
                                give_item(id, "weapon_smokegrenade");
                                cs_set_user_bpammo(id, CSW_HEGRENADE, 6);
                                cs_set_user_bpammo(id, CSW_FLASHBANG, 6);
                                cs_set_user_bpammo(id, CSW_SMOKEGRENADE, 6);
                                
                                give_item(id, "weapon_deagle");
                                cs_set_weapon_ammo(dgl, 7);
                                
                                cs_set_user_bpammo(id, CSW_DEAGLE, 0);
                                set_user_health(id, get_user_health(id) + 500);
                                remove_task(id);
                        }
                }
                        
        }

}

UpdateLevel(id)
{
        if((hnsxp_playerlevel[id] < 101) && (hnsxp_playerxp[id] >= LEVELS[hnsxp_playerlevel[id]]))
        {
                MesajColorat(id,"!normal[!echipa%s!normal] Felicitari ai trecut la nivelul urmator !", PLUGIN_NAME);
                MesajColorat(id,"!normal[!echipa%s!normal] Felicitari ai trecut la nivelul urmator !", PLUGIN_NAME);
                MesajColorat(id,"!normal[!echipa%s!normal] Felicitari ai trecut la nivelul urmator !", PLUGIN_NAME);
                MesajColorat(id,"!normal[!echipa%s!normal] Felicitari ai trecut la nivelul urmator !", PLUGIN_NAME);
                MesajColorat(id,"!normal[!echipa%s!normal] Felicitari ai trecut la nivelul urmator !", PLUGIN_NAME);
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
        
        MesajColorat(id, "!normal[!echipaLevel Mod!normal] !verdeLVL !normal: !echipa%i !normal, !verdeXP !normal: !echipa %i !normal/ !echipa%i ", hnsxp_playerlevel[id], hnsxp_playerxp[id], LEVELS[hnsxp_playerlevel[id]]);
        return PLUGIN_HANDLED
}

public plvls(id)
{
        new players[32], playersnum, name[40], motd[1024], len;
        
        len = formatex(motd, charsmax(motd), "<html> <center> <font color=red> <b>LEVEL                NUME                XP        <br ></font> </b> <body bgcolor=black> ");
        get_players(players, playersnum);
        
        for ( new i = 0 ; i < playersnum ; i++ ) {
                get_user_name(players[i], name, charsmax(name));
                len += formatex(motd[len], charsmax(motd) - len, "<br><font color=red> <b> [%i]        %s:         %i</font> </b> </center> ",hnsxp_playerlevel[players[i]], name, hnsxp_playerxp[players[i]]);
        }
        
        formatex(motd[len], charsmax(motd) - len, "</html>");
        show_motd(id, motd);
        return PLUGIN_HANDLED
        
        
}
public tlvl(id)
{
        new poj_Name [ 32 ];
        get_user_name(id, poj_Name, 31)
        MesajColorat(0, "!normal[!echipaLevel-Mod!normal] Jucatorul !echipa%s !normalare nivelul !verde%i",poj_Name, hnsxp_playerlevel[id]);
        return PLUGIN_HANDLED
}

public hnsxp_death( iVictim, attacker, shouldgib )
{
        
        if( !attacker || attacker == iVictim )
                return;
        
        hnsxp_playerxp[attacker] += get_pcvar_num(hnsxp_kill);
        new ret;
        ExecuteForward(wxp, ret, attacker);
        MesajColorat(attacker,"!normal[!echipa%s!normal] Ai primit !echipa%i !normalXP pentru ca l-ai omorat pe !echipa%s!", PLUGIN_NAME, get_pcvar_num(hnsxp_kill), iVictim);
        
        UpdateLevel(attacker);
        UpdateLevel(iVictim);
        checkandupdatetop(iVictim),hnsxp_playerlevel[iVictim]);
        checkandupdatetop(attacker,hnsxp_playerlevel[attacker]);

        if(get_user_flags(attacker) & ADMIN_IMMUNITY && get_pcvar_num(vip_enable))
        {
                        hnsxp_playerxp[attacker] += get_pcvar_num(vip_xp);
                        MesajColorat(attacker, "!echipa[%s]!verde Ai primit un bonus de %i xp pentru ca esti VIP !",PLUGIN_NAME,get_pcvar_num(vip_xp));
        }
}

public client_connect(id)
{
        if(get_pcvar_num(hnsxp_savexp) == 1)
                LoadData(id);
               
}
public client_disconnect(id)
{
        if(get_pcvar_num(hnsxp_savexp) == 1)
                SaveData(id);
        
        hnsxp_playerxp[id] = 0;
        hnsxp_playerlevel[id] = 0;
        
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

public cmd_set_xp(id, level, cid)
{
        if(!cmd_access(id, level, cid, 3))
                return PLUGIN_HANDLED
        
        new target[32], amount[221], reason[21]
        
        read_argv(1, target, 31)
        read_argv(2, amount, 220)
        read_argv(3, reason, 20)
        
        new player = cmd_target(id, target, 8)
        
        if(!player)
                return PLUGIN_HANDLED
        
        new admin_name[32], player_name[32]
        get_user_name(id, admin_name, 31)
        get_user_name(player, player_name, 31)
        
        new expnum = str_to_num(amount)
        MesajColorat(0, "!normal[ADMIN] !echipa%s: !normalia setat XP !echipa%s !normallui !echipa%s", admin_name, amount, player_name)
        
        hnsxp_playerxp[player] = expnum
        new ret;
        ExecuteForward(wxp, ret, player);

        UpdateLevel(player);
        checkandupdatetop(player,hnsxp_playerlevel[player])

        SaveData(player)
        SaveData(id)
        
        return PLUGIN_CONTINUE
}

public cmd_set_level(id, level, cid)
{
        if(!cmd_access(id, level, cid, 3))
                return PLUGIN_HANDLED
        
        new target[32], amount[221], reason[21]
        
        read_argv(1, target, 31)
        read_argv(2, amount, 220)
        read_argv(3, reason, 20)
        
        new player = cmd_target(id, target, 8)
        
        if(!player)
                return PLUGIN_HANDLED
        
        new admin_name[32], player_name[32]
        
        get_user_name(id, admin_name, 31)
        get_user_name(player, player_name, 31)
        
        new expnum = str_to_num(amount)
        MesajColorat(0, "!normal[ADMIN] !echipa%s: !normalia setat LVL !echipa%s !normallui !echipa%s", admin_name, amount, player_name)
        
        hnsxp_playerlevel[player] = expnum
        SaveData(player)
        checkandupdatetop(player,hnsxp_playerlevel[player])
        
        return PLUGIN_CONTINUE
}
public t_win(id)
{
        
        new iPlayer [ 32 ], iNum;
        get_players(iPlayer, iNum, "ae", "TERRORIST")
        for ( new i = 0; i < iNum; i++ ) {
                hnsxp_playerxp[iPlayer [ i ]] += get_pcvar_num(tero_win);
                MesajColorat(iPlayer[i], "!normal[!echipaLevel Mod!normal] Ai primit !verde %i !normalxp pentru ca echipa !verdeTERO a castigat !",get_pcvar_num(tero_win));
                UpdateLevel(iPlayer[i]);
                checkandupdatetop(iPlayer[i],hnsxp_playerlevel[iPlayer[i]])
        }
}
stock MesajColorat(const id, const input[], any:...)
{
        new count = 1, players[32]
        static msg[191]
        vformat(msg, 190, input, 3)
        
        replace_all(msg, 190, "!verde", "^4")
        replace_all(msg, 190, "!normal", "^1")
        replace_all(msg, 190, "!echipa", "^3")
        
        if (id) players[0] = id; else get_players(players, count, "ch")
        {
                for (new i = 0; i < count; i++)
                {
                        if (is_user_connected(players[i]))
                        {
                                message_begin(MSG_ONE_UNRELIABLE, get_user_msgid("SayText"), _, players[i])
                                write_byte(players[i]);
                                write_string(msg);
                                message_end();
                        }
                }
        }
}
