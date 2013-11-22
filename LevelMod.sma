/* AMX Mod X
*  Level Mod Plugin
*
*  by LordOfNothing
*
*  This file is part of AMX Mod X.
*
*
*  This program is free software; you can redistribute it and/or modify it
*  under the terms of the GNU General Public License as published by the
*  Free Software Foundation; either version 2 of the License, or (at
*  your option) any later version.
*
*  This program is distributed in the hope that it will be useful, but
*  WITHOUT ANY WARRANTY; without even the implied warranty of
*  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
*  General Public License for more details.
*
*  You should have received a copy of the GNU General Public License
*  along with this program; if not, write to the Free Software Foundation, 
*  Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
*
*  In addition, as a special exception, the author gives permission to
*  link the code of this program with the Half-Life Game Engine ("HL
*  Engine") and Modified Game Libraries ("MODs") developed by Valve, 
*  L.L.C ("Valve"). You must obey the GNU General Public License in all
*  respects for all of the code used other than the HL Engine and MODs
*  from Valve. If you modify this file, you may extend this exception
*  to your version of the file, but you are not obligated to do so. If
*  you do not wish to do so, delete this exception statement from your
*  version.
*/

#include <amxmodx>
#include <amxmisc>
#include <fun>
#include <hamsandwich>
#include <nvault>
#include <fakemeta>
#include <cstrike>

new const PLUGIN_NAME[] = "Level Mod";
new const hnsxp_version[] = "4.8";
new const LEVELS[99] = {
        
        100, // 1
        300, // 2
        500, // 3
        700, // 4
        900, // 5
        1000, // 6
        1500, // 7
        2000, // 8
        2500, // 10
        3000, // 11
        4000, // 12
        5000, // 13
        6000, // 14
        7000, // 15
        10000, // 16
        12000, // 17
        13000, // 18
        15000, // 19
        20000, // 20
        25000, // 21
        30000, // 22
        35000, // 23
        40000, // 24
        45000, // 25
        50000, // 26
        60000, // 27
        70000, // 28
        80000, // 29
        100000, // 30
        120000, // 31
        130000, //32
        140000, // 33
        150000, // 34
        160000, // 35
        170000, // 36
        180000, // 37
        190000, // 38
        195000, // 39
        200000, // 40
        250000, // 41
        300000, // 42
        350000, // 43
        400000, // 44
        500000, // 45
        600000, // 46
        700000, // 47
        800000, // 48
        900000, // 49
        1000000, // 50
        1300000, // 51
        1500000, // 2
        1800000, // 3
        2000000, // 4
        2250000, // 5
        2500000, // 6
        2750000, // 7
        2900000, // 8
        3000000, // 10
        3500000, // 11
        4000000, // 12
        4500000, // 13
        5000000, // 14
        5500000, // 15
        6000000, // 16
        6500000, // 17
        7000000, // 18
        7500000, // 19
        8500000, // 20
        9000000, // 21
        10000000, // 22
        11000000, // 23
        22000000, // 24
        23000000, // 25
        24000000, // 26
        25000000, // 27
        26000000, // 28
        27000000, // 29
        28000000, // 30
        29000000, // 31
        30000000, //32
        40000000, // 33
        50000000, // 34
        60000000, // 35
        70000000, // 36
        80000000, // 37
        90000000, // 38
        100000000, // 39
        150000000, // 40
        200000000, // 41
        300000000, // 42
        400000000, // 43
        500000000, // 44
        600000000, // 45
        700000000, // 46
        750000000, // 47
        850000000, // 48
        909990000, // 97
        1000000000, // 98
        1000500000, // 99
        2000000000 // 100
        
        
}
new hnsxp_playerxp[33], hnsxp_playerlevel[33];
new hnsxp_kill, hnsxp_savexp, g_hnsxp_vault, healthlvl, buyenable, buycost, xpbuy, tero_win, item_time ,vip_enable, vip_xp;

#define IsPlayer(%0)    ( 1 <= %0 <= g_iMaxPlayers )

new g_iMaxPlayers, damagecvar;


public plugin_init()
{
        register_plugin(PLUGIN_NAME, hnsxp_version, "LordOfNothing");
        
        RegisterHam(Ham_Spawn, "player", "hnsxp_spawn", 1);
        RegisterHam(Ham_Killed, "player", "hnsxp_death", 1);
        
        hnsxp_savexp = register_cvar("hnsxp_savexp","1");
        hnsxp_kill = register_cvar("hnsxp_kill", "500");
        healthlvl = register_cvar("hnsxp_health_level","10");
        buyenable = register_cvar("hnsxp_enable_buy","1");
        buycost = register_cvar("hnsxp_buy_money","2");
        xpbuy = register_cvar("hnsxp_buy_xp","500");
        tero_win = register_cvar("hnsxp_terowin_xp","400");
        item_time = register_cvar("hnsxp_item_time","20.0");
        vip_enable = register_cvar("hnsxp_vip_enable","1");
        vip_xp = register_cvar("hnsxp_vip_xp","10000");
        damagecvar = register_cvar("hnsxp_damage_level","10.0");

        
        register_clcmd("say /buyxp","Buy_Xp");
        register_clcmd("say_team /buyxp","Buy_Xp");
        
        register_clcmd("say /level","plvl");
        register_clcmd("say /xp","plvl");
        
        register_clcmd("say /levels","plvls");
        register_clcmd("say_team /level","plvl");
        register_clcmd("say_team /xp","plvl");
        
        register_clcmd("say /lvl","tlvl");
        g_hnsxp_vault = nvault_open("deathrun_xp");
        
        register_concmd("amx_level", "cmd_give_level", ADMIN_CVAR, "<target> <amount>");
        register_concmd("amx_takelevel", "cmd_take_level", ADMIN_CVAR, "<target> <amount>");
        
        register_concmd("amx_xp", "cmd_give_xp", ADMIN_CVAR, "<target> <amount>");
        register_concmd("amx_takexp", "cmd_take_xp", ADMIN_CVAR, "<target> <amount>");
        
        register_event("SendAudio", "t_win", "a", "2&%!MRAD_terwin")
        
        
        g_iMaxPlayers = get_maxplayers ( )
        RegisterHam ( Ham_TakeDamage, "player", "Player_TakeDamage",1);

    
}

public Player_TakeDamage ( iVictim, iInflictor, iAttacker, Float:fDamage ) {
    
        if ( iInflictor == iAttacker && IsPlayer ( iAttacker ) ) {
                
                SetHamParamFloat ( 4, hnsxp_playerlevel[iAttacker] * get_pcvar_float(damagecvar) + fDamage  );
                return HAM_HANDLED;
        }
        return HAM_IGNORED;
}

public Buy_Xp(id)
{
        new iMoney = cs_get_user_money(id);
        new iCost = get_pcvar_num(buycost);
        new iGiveXp = get_pcvar_num(xpbuy);
        
        if(!get_pcvar_num(buyenable))
                return PLUGIN_HANDLED
        if(is_user_alive(id))
        {
                if(iMoney >= iCost )
                {
                        hnsxp_playerxp[id] += iGiveXp;
                        cs_set_user_money( id, cs_get_user_money( id ) - iCost );
                        MesajColorat(id, "!echipa[%s] !verdeTocmai ai cumparat !echipa%i !verdexp pentru suma de !echipa%i !verde$",PLUGIN_NAME,iGiveXp,iCost);
                        return PLUGIN_HANDLED
                }else{
                        MesajColorat(id, "!echipa[%s] !verdeNu ai atatia bani !",PLUGIN_NAME);
                        return PLUGIN_HANDLED
                }
        }else{
                MesajColorat(id, "!echipa[%s] !verdeTrebuie sa fii in viata ! !",PLUGIN_NAME);
                return PLUGIN_HANDLED
        }
        return PLUGIN_CONTINUE
}
public hnsxp_spawn(id)
{ 
        set_task(get_pcvar_float(item_time), "gItem", id);

        if((hnsxp_playerlevel[id] < 99) && (hnsxp_playerxp[id] >= LEVELS[hnsxp_playerlevel[id]]))
        {
                MesajColorat(id,"!echipa[%s] !verdeAi trecut levelul", PLUGIN_NAME);
                while(hnsxp_playerxp[id] >= LEVELS[hnsxp_playerlevel[id]])
                {
                        hnsxp_playerlevel[id] += 1;
                }
        }
        
        if(hnsxp_playerlevel[id] > 0)
                set_user_health(id, get_user_health(id) + get_pcvar_num(healthlvl)*hnsxp_playerlevel[id]);
}

public plvl(id)
{
        
        MesajColorat(id, "!echipa[Level Mod] !verdeLevel : !echipa %i , !verdeXP: !echipa %i / %i ", hnsxp_playerlevel[id], hnsxp_playerxp[id], LEVELS[hnsxp_playerlevel[id]]);
        return PLUGIN_HANDLED
}

public plvls(id)
{
        new players[32], playersnum, name[40], motd[1024], len;
        
        len = formatex(motd, charsmax(motd), "<html> Level Mod by LordOfNothing ! <br >");
        get_players(players, playersnum);
        
        for ( new i = 0 ; i < playersnum ; i++ ) {
                get_user_name(players[i], name, charsmax(name));
                len += formatex(motd[len], charsmax(motd) - len, "<br> <center>[LEVEL %i] %s [XP %i / %i]</center> ",hnsxp_playerlevel[players[i]], name,  hnsxp_playerxp[players[i]], LEVELS[hnsxp_playerlevel[players[i]]]);
        }
        
        formatex(motd[len], charsmax(motd) - len, "</html>");
        show_motd(id, motd);
        return PLUGIN_HANDLED
        
        
}
public tlvl(id)
{
        new poj_Name [ 32 ];
        get_user_name(id, poj_Name, 31)
        MesajColorat(0, "!verde[!echipaLevel-Mod!verde] !normal Jucatorul !verde %s !normalare level !verde %i",poj_Name, hnsxp_playerlevel[id]);
        return PLUGIN_HANDLED
}
public gItem(id)
{
        switch(hnsxp_playerlevel[id])
        {
                case 1..20:
                {
                cs_set_weapon_ammo(give_item(id, "weapon_deagle"), 1)
                cs_set_user_bpammo( id, CSW_DEAGLE, 0 )
                give_item(id, "weapon_smokegrenade")
                cs_set_user_bpammo(id, CSW_SMOKEGRENADE, 1)
                give_item(id, "weapon_flashbang")
                cs_set_user_bpammo(id, CSW_FLASHBANG, 1)
                give_item(id, "weapon_hegrenade")
                cs_set_user_bpammo(id, CSW_HEGRENADE, 1)
                remove_task(id);  
                }
                case 21..30:
                {
                cs_set_weapon_ammo(give_item(id, "weapon_deagle"), 2)
                cs_set_user_bpammo( id, CSW_DEAGLE, 0 )
                give_item(id, "weapon_smokegrenade")
                cs_set_user_bpammo(id, CSW_SMOKEGRENADE, 2)
                give_item(id, "weapon_flashbang")
                cs_set_user_bpammo(id, CSW_FLASHBANG, 2)
                give_item(id, "weapon_hegrenade")
                cs_set_user_bpammo(id, CSW_HEGRENADE, 2)
                remove_task(id);
                }
                case 31..40:
                {
                cs_set_weapon_ammo(give_item(id, "weapon_deagle"), 3)
                cs_set_user_bpammo( id, CSW_DEAGLE, 0 )
                give_item(id, "weapon_smokegrenade")
                cs_set_user_bpammo(id, CSW_SMOKEGRENADE, 3)
                give_item(id, "weapon_flashbang")
                cs_set_user_bpammo(id, CSW_FLASHBANG, 3)
                give_item(id, "weapon_hegrenade")
                cs_set_user_bpammo(id, CSW_HEGRENADE, 3)
                remove_task(id); 
                }
                case 41..50:
                {
                cs_set_weapon_ammo(give_item(id, "weapon_deagle"), 4)
                cs_set_user_bpammo( id, CSW_DEAGLE, 0 )
                give_item(id, "weapon_smokegrenade")
                cs_set_user_bpammo(id, CSW_SMOKEGRENADE, 3)
                give_item(id, "weapon_flashbang")
                cs_set_user_bpammo(id, CSW_FLASHBANG, 3)
                give_item(id, "weapon_hegrenade")
                cs_set_user_bpammo(id, CSW_HEGRENADE, 3)
                remove_task(id); 
                }
                case 51..60:
                {
                cs_set_weapon_ammo(give_item(id, "weapon_deagle"), 4)
                cs_set_user_bpammo( id, CSW_DEAGLE, 0 )
                give_item(id, "weapon_smokegrenade")
                cs_set_user_bpammo(id, CSW_SMOKEGRENADE, 3)
                give_item(id, "weapon_flashbang")
                cs_set_user_bpammo(id, CSW_FLASHBANG, 3)
                give_item(id, "weapon_hegrenade")
                cs_set_user_bpammo(id, CSW_HEGRENADE, 3)
                remove_task(id); 
                }
                case 61..94:
                {
                cs_set_weapon_ammo(give_item(id, "weapon_deagle"), 6)
                cs_set_user_bpammo( id, CSW_DEAGLE, 0 )
                give_item(id, "weapon_smokegrenade")
                cs_set_user_bpammo(id, CSW_SMOKEGRENADE, 3)
                give_item(id, "weapon_flashbang")
                cs_set_user_bpammo(id, CSW_FLASHBANG, 3)
                give_item(id, "weapon_hegrenade")
                cs_set_user_bpammo(id, CSW_HEGRENADE, 3)
                remove_task(id); 
                }
                case 95..99:
                {
                cs_set_weapon_ammo(give_item(id, "weapon_deagle"), 7)
                cs_set_user_bpammo( id, CSW_DEAGLE, 0 )
                give_item(id, "weapon_smokegrenade")
                cs_set_user_bpammo(id, CSW_SMOKEGRENADE, 3)
                give_item(id, "weapon_flashbang")
                cs_set_user_bpammo(id, CSW_FLASHBANG, 3)
                give_item(id, "weapon_hegrenade")
                cs_set_user_bpammo(id, CSW_HEGRENADE, 3)
                set_user_gravity(id, 0.7);
                set_user_health(id, get_user_health(id) + get_pcvar_num(healthlvl)*hnsxp_playerlevel[id]);        
                remove_task(id); 
                }
        }
}
public hnsxp_death( iVictim, attacker, shouldgib )
{
        
        if( !attacker || attacker == iVictim )
                return;
        
        hnsxp_playerxp[attacker] += get_pcvar_num(hnsxp_kill);
        MesajColorat(attacker,"!echipa[%s] !verdeAi primit %i XP pentru ca l-ai omorat pe %s!", PLUGIN_NAME, get_pcvar_num(hnsxp_kill), iVictim);
        
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
}
public SaveData(id)
{
        new PlayerName[35];
        get_user_name(id,PlayerName,34);
        
        new vaultkey[64],vaultdata[256];
        format(vaultkey,63,"%s",PlayerName);
        format(vaultdata,255,"%i`%i`",hnsxp_playerxp[id],hnsxp_playerlevel[id]);
        nvault_set(g_hnsxp_vault,vaultkey,vaultdata);
        return PLUGIN_CONTINUE;
}
public LoadData(id)
{
        new PlayerName[35];
        get_user_name(id,PlayerName,34);
        
        new vaultkey[64],vaultdata[256];
        format(vaultkey,63,"%s",PlayerName);
        format(vaultdata,255,"%i`%i`",hnsxp_playerxp[id],hnsxp_playerlevel[id]);
        nvault_get(g_hnsxp_vault,vaultkey,vaultdata,255);
        
        replace_all(vaultdata, 255, "`", " ");
        
        new playerxp[32], playerlevel[32];
        
        parse(vaultdata, playerxp, 31, playerlevel, 31);
        
        hnsxp_playerxp[id] = str_to_num(playerxp);
        hnsxp_playerlevel[id] = str_to_num(playerlevel);
        
        return PLUGIN_CONTINUE;
}
public cmd_give_level(id, level, cid)
{
        if(!cmd_access(id, level, cid, 3))
                return PLUGIN_HANDLED
        
        new target[32], amount[21], reason[21]
        
        read_argv(1, target, 31)
        read_argv(2, amount, 20)
        read_argv(3, reason, 20)
        
        new player = cmd_target(id, target, 8)
        
        if(!player)
                return PLUGIN_HANDLED
        
        new admin_name[32], player_name[32]
        get_user_name(id, admin_name, 31)
        get_user_name(player, player_name, 31)
        
        new expnum = str_to_num(amount)
        MesajColorat(0, "!echipaADMIN %s: !verdeia dat %s level lui %s", admin_name, amount, player_name)
        
        hnsxp_playerlevel[player] += expnum
        SaveData(id)
        
        return PLUGIN_CONTINUE
}
public cmd_give_xp(id, level, cid)
{
        if(!cmd_access(id, level, cid, 3))
                return PLUGIN_HANDLED
        
        new target[32], amount[21], reason[21]
        
        read_argv(1, target, 31)
        read_argv(2, amount, 20)
        read_argv(3, reason, 20)
        
        new player = cmd_target(id, target, 8)
        
        if(!player)
                return PLUGIN_HANDLED
        
        new admin_name[32], player_name[32]
        get_user_name(id, admin_name, 31)
        get_user_name(player, player_name, 31)
        
        new expnum = str_to_num(amount)
        MesajColorat(0, "!echipaADMIN %s: !verdeia dat %s xp lui %s", admin_name, amount, player_name)
        
        hnsxp_playerxp[player] += expnum
        SaveData(id)
        
        return PLUGIN_CONTINUE
}
public cmd_take_level(id, level, cid)
{
        if(!cmd_access(id, level, cid, 3))
                return PLUGIN_HANDLED
        
        new target[32], amount[21], reason[21]
        
        read_argv(1, target, 31)
        read_argv(2, amount, 20)
        read_argv(3, reason, 20)
        
        new player = cmd_target(id, target, 8)
        
        if(!player)
                return PLUGIN_HANDLED
        
        new admin_name[32], player_name[32]
        
        get_user_name(id, admin_name, 31)
        get_user_name(player, player_name, 31)
        
        new expnum = str_to_num(amount)
        MesajColorat(0, "!echipaADMIN %s: !verdeia luat %s level lui %s", admin_name, amount, player_name)
        
        hnsxp_playerlevel[player] -= expnum
        SaveData(id)
        
        return PLUGIN_CONTINUE
}
public cmd_take_xp(id, level, cid)
{
        if(!cmd_access(id, level, cid, 3))
                return PLUGIN_HANDLED
        
        new target[32], amount[21], reason[21]
        
        read_argv(1, target, 31)
        read_argv(2, amount, 20)
        read_argv(3, reason, 20)
        
        new player = cmd_target(id, target, 8)
        
        if(!player)
                return PLUGIN_HANDLED
        
        new admin_name[32], player_name[32]
        
        get_user_name(id, admin_name, 31)
        get_user_name(player, player_name, 31)
        
        new expnum = str_to_num(amount)
        MesajColorat(0, "!echipaADMIN %s: !verdeia luat %s level lui %s", admin_name, amount, player_name)
        
        hnsxp_playerxp[player] -= expnum
        SaveData(id)
        
        return PLUGIN_CONTINUE
}
public t_win(id)
{
        
        new iPlayer [  32 ], iNum;
        get_players(iPlayer, iNum, "ae", "TERRORIST")
        for ( new i = 0; i < iNum; i++ ) {
                hnsxp_playerxp[iPlayer [ i ]] += get_pcvar_num(tero_win);
                MesajColorat(iPlayer[i], "!echipa[Level Mod] !verdeAi primit !echipa %i xp !verde pentru ca echipa !echipaT !verdea castigat !",get_pcvar_num(tero_win));
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
