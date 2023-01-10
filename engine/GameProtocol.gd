extends Resource
class_name GameProtocol

signal logged
signal error_message(message)
signal parse_data(packet_id, data)

enum ServerPacketID{
	Logged                  #LOGGED
	RemoveDialogs           #QTDL
	RemoveCharDialog        #QDL
	NavigateToggle          #NAVEG
	Disconnect              #FINOK
	CommerceEnd             #FINCOMOK
	BankEnd                 #FINBANOK
	CommerceInit            #INITCOM
	BankInit                #INITBANCO
	UserCommerceInit        #INITCOMUSU
	UserCommerceEnd         #FINCOMUSUOK
	ShowBlacksmithForm      #SFH
	ShowCarpenterForm       #SFC
	NPCSwing                #N1
	NPCKillUser             #6
	BlockedWithShieldUser   #7
	BlockedWithShieldOther  #8
	UserSwing               #U1
	UpdateNeeded            #REAU
	SafeModeOn              #SEGON
	SafeModeOff             #SEGOFF
	ResuscitationSafeOn
	ResuscitationSafeOff
	NobilityLost            #PN
	CantUseWhileMeditating  #M!
	UpdateSta               #ASS
	UpdateMana              #ASM
	UpdateHP                #ASH
	UpdateGold              #ASG
	UpdateExp               #ASE
	ChangeMap               #CM
	PosUpdate               #PU
	NPCHitUser              #N2
	UserHitNPC              #U2
	UserAttackedSwing       #U3
	UserHittedByUser        #N4
	UserHittedUser          #N5
	ChatOverHead            #||
	ConsoleMsg              #|| - Beware!! its the same as above, but it was properly splitted
	GuildChat               #|+
	ShowMessageBox          #!!
	UserIndexInServer       #IU
	UserCharIndexInServer   #IP
	CharacterCreate         #CC
	CharacterRemove         #BP
	CharacterMove           #MP, +, * and _ #
	CharacterChange         #CP
	ObjectCreate            #HO
	ObjectDelete            #BO
	BlockPosition           #BQ
	PlayMidi                #TM
	PlayWave                #TW
	guildList               #GL
	AreaChanged             #CA
	PauseToggle             #BKW
	RainToggle              #LLU
	CreateFX                #CFX
	UpdateUserStats         #EST
	WorkRequestTarget       #T01
	ChangeInventorySlot     #CSI
	ChangeBankSlot          #SBO
	ChangeSpellSlot         #SHS
	atributes               #ATR
	BlacksmithWeapons       #LAH
	BlacksmithArmors        #LAR
	CarpenterObjects        #OBR
	RestOK                  #DOK
	ErrorMsg                #ERR
	Blind                   #CEGU
	Dumb                    #DUMB
	ShowSignal              #MCAR
	ChangeNPCInventorySlot  #NPCI
	UpdateHungerAndThirst   #EHYS
	Fame                    #FAMA
	MiniStats               #MEST
	LevelUp                 #SUNI
	AddForumMsg             #FMSG
	ShowForumForm           #MFOR
	SetInvisible            #NOVER
	DiceRoll                #DADOS
	MeditateToggle          #MEDOK
	BlindNoMore             #NSEGUE
	DumbNoMore              #NESTUP
	SendSkills              #SKILLS
	TrainerCreatureList     #LSTCRI
	guildNews               #GUILDNE
	OfferDetails            #PEACEDE & ALLIEDE
	AlianceProposalsList    #ALLIEPR
	PeaceProposalsList      #PEACEPR
	CharacterInfo           #CHRINFO
	GuildLeaderInfo         #LEADERI
	GuildDetails            #CLANDET
	ShowGuildFundationForm  #SHOWFUN
	ParalizeOK              #PARADOK
	ShowUserRequest         #PETICIO
	TradeOK                 #TRANSOK
	BankOK                  #BANCOOK
	ChangeUserTradeSlot     #COMUSUINV
	SendNight               #NOC
	Pong
	UpdateTagAndStatus
	
	#GM messages
	SpawnList               #SPL
	ShowSOSForm             #MSOS
	ShowMOTDEditionForm     #ZMOTD
	ShowGMPanelForm         #ABPANEL
	UserNameList            #LISTUSU
 }

enum ClientPacketID{
	LoginExistingChar       #OLOGIN
	ThrowDices              #TIRDAD
	LoginNewChar            #NLOGIN
	Talk                    #;
	Yell                    #-
	Whisper                 #\
	Walk                    #M
	RequestPositionUpdate   #RPU
	Attack                  #AT
	PickUp                  #AG
	CombatModeToggle        #TAB        - SHOULD BE HANLDED JUST BY THE CLIENT!!
	SafeToggle              #/SEG & SEG  (SEG#s behaviour has to be coded in the client)
	ResuscitationSafeToggle
	RequestGuildLeaderInfo  #GLINFO
	RequestAtributes        #ATR
	RequestFame             #FAMA
	RequestSkills           #ESKI
	RequestMiniStats        #FEST
	CommerceEnd             #FINCOM
	UserCommerceEnd         #FINCOMUSU
	BankEnd                 #FINBAN
	UserCommerceOk          #COMUSUOK
	UserCommerceReject      #COMUSUNO
	Drop                    #TI
	CastSpell               #LH
	LeftClick               #LC
	DoubleClick             #RC
	Work                    #UK
	UseSpellMacro           #UMH
	UseItem                 #USA
	CraftBlacksmith         #CNS
	CraftCarpenter          #CNC
	WorkLeftClick           #WLC
	CreateNewGuild          #CIG
	SpellInfo               #INFS
	EquipItem               #EQUI
	ChangeHeading           #CHEA
	ModifySkills            #SKSE
	Train                   #ENTR
	CommerceBuy             #COMP
	BankExtractItem         #RETI
	CommerceSell            #VEND
	BankDeposit             #DEPO
	ForumPost               #DEMSG
	MoveSpell               #DESPHE
	ClanCodexUpdate         #DESCOD
	UserCommerceOffer       #OFRECER
	GuildAcceptPeace        #ACEPPEAT
	GuildRejectAlliance     #RECPALIA
	GuildRejectPeace        #RECPPEAT
	GuildAcceptAlliance     #ACEPALIA
	GuildOfferPeace         #PEACEOFF
	GuildOfferAlliance      #ALLIEOFF
	GuildAllianceDetails    #ALLIEDET
	GuildPeaceDetails       #PEACEDET
	GuildRequestJoinerInfo  #ENVCOMEN
	GuildAlliancePropList   #ENVALPRO
	GuildPeacePropList      #ENVPROPP
	GuildDeclareWar         #DECGUERR
	GuildNewWebsite         #NEWWEBSI
	GuildAcceptNewMember    #ACEPTARI
	GuildRejectNewMember    #RECHAZAR
	GuildKickMember         #ECHARCLA
	GuildUpdateNews         #ACTGNEWS
	GuildMemberInfo         #1HRINFO<
	GuildOpenElections      #ABREELEC
	GuildRequestMembership  #SOLICITUD
	GuildRequestDetails     #CLANDETAILS
	Online                  #/ONLINE
	Quit                    #/SALIR
	GuildLeave              #/SALIRCLAN
	RequestAccountState     #/BALANCE
	PetStand                #/QUIETO
	PetFollow               #/ACOMPAÑAR
	TrainList               #/ENTRENAR
	Rest                    #/DESCANSAR
	Meditate                #/MEDITAR
	Resucitate              #/RESUCITAR
	Heal                    #/CURAR
	Help                    #/AYUDA
	RequestStats            #/EST
	CommerceStart           #/COMERCIAR
	BankStart               #/BOVEDA
	Enlist                  #/ENLISTAR
	Information             #/INFORMACION
	Reward                  #/RECOMPENSA
	RequestMOTD             #/MOTD
	UpTime                  #/UPTIME
	PartyLeave              #/SALIRPARTY
	PartyCreate             #/CREARPARTY
	PartyJoin               #/PARTY
	Inquiry                 #/ENCUESTA ( with no params )
	GuildMessage            #/CMSG
	PartyMessage            #/PMSG
	CentinelReport          #/CENTINELA
	GuildOnline             #/ONLINECLAN
	PartyOnline             #/ONLINEPARTY
	CouncilMessage          #/BMSG
	RoleMasterRequest       #/ROL
	GMRequest               #/GM
	bugReport               #/_BUG
	ChangeDescription       #/DESC
	GuildVote               #/VOTO
	Punishments             #/PENAS
	ChangePassword          #/CONTRASEÑA
	Gamble                  #/APOSTAR
	InquiryVote             #/ENCUESTA ( with parameters )
	LeaveFaction            #/RETIRAR ( with no arguments )
	BankExtractGold         #/RETIRAR ( with arguments )
	BankDepositGold         #/DEPOSITAR
	Denounce                #/DENUNCIAR
	GuildFundate            #/FUNDARCLAN
	PartyKick               #/ECHARPARTY
	PartySetLeader          #/PARTYLIDER
	PartyAcceptMember       #/ACCEPTPARTY
	Ping                    #/PING
	
	#GM messages
	GMMessage               #/GMSG
	showName                #/SHOWNAME
	OnlineRoyalArmy         #/ONLINEREAL
	OnlineChaosLegion       #/ONLINECAOS
	GoNearby                #/IRCERCA
	comment                 #/REM
	serverTime              #/HORA
	Where                   #/DONDE
	CreaturesInMap          #/NENE
	WarpMeToTarget          #/TELEPLOC
	WarpChar                #/TELEP
	Silence                 #/SILENCIAR
	SOSShowList             #/SHOW SOS
	SOSRemove               #SOSDONE
	GoToChar                #/IRA
	invisible               #/INVISIBLE
	GMPanel                 #/PANELGM
	RequestUserList         #LISTUSU
	Working                 #/TRABAJANDO
	Hiding                  #/OCULTANDO
	Jail                    #/CARCEL
	KillNPC                 #/RMATA
	WarnUser                #/ADVERTENCIA
	EditChar                #/MOD
	RequestCharInfo         #/INFO
	RequestCharStats        #/STAT
	RequestCharGold         #/BAL
	RequestCharInventory    #/INV
	RequestCharBank         #/BOV
	RequestCharSkills       #/SKILLS
	ReviveChar              #/REVIVIR
	OnlineGM                #/ONLINEGM
	OnlineMap               #/ONLINEMAP
	Forgive                 #/PERDON
	Kick                    #/ECHAR
	Execute                 #/EJECUTAR
	BanChar                 #/BAN
	UnbanChar               #/UNBAN
	NPCFollow               #/SEGUIR
	SummonChar              #/SUM
	SpawnListRequest        #/CC
	SpawnCreature           #SPA
	ResetNPCInventory       #/RESETINV
	CleanWorld              #/LIMPIAR
	ServerMessage           #/RMSG
	NickToIP                #/NICK2IP
	IPToNick                #/IP2NICK
	GuildOnlineMembers      #/ONCLAN
	TeleportCreate          #/CT
	TeleportDestroy         #/DT
	RainToggle              #/LLUVIA
	SetCharDescription      #/SETDESC
	ForceMIDIToMap          #/FORCEMIDIMAP
	ForceWAVEToMap          #/FORCEWAVMAP
	RoyalArmyMessage        #/REALMSG
	ChaosLegionMessage      #/CAOSMSG
	CitizenMessage          #/CIUMSG
	CriminalMessage         #/CRIMSG
	TalkAsNPC               #/TALKAS
	DestroyAllItemsInArea   #/MASSDEST
	AcceptRoyalCouncilMember #/ACEPTCONSE
	AcceptChaosCouncilMember #/ACEPTCONSECAOS
	ItemsInTheFloor         #/PISO
	MakeDumb                #/ESTUPIDO
	MakeDumbNoMore          #/NOESTUPIDO
	DumpIPTables            #/DUMPSECURITY
	CouncilKick             #/KICKCONSE
	SetTrigger              #/TRIGGER
	AskTrigger              #/TRIGGER with no args
	BannedIPList            #/BANIPLIST
	BannedIPReload          #/BANIPRELOAD
	GuildMemberList         #/MIEMBROSCLAN
	GuildBan                #/BANCLAN
	BanIP                   #/BANIP
	UnbanIP                 #/UNBANIP
	CreateItem              #/CI
	DestroyItems            #/DEST
	ChaosLegionKick         #/NOCAOS
	RoyalArmyKick           #/NOREAL
	ForceMIDIAll            #/FORCEMIDI
	ForceWAVEAll            #/FORCEWAV
	RemovePunishment        #/BORRARPENA
	TileBlockedToggle       #/BLOQ
	KillNPCNoRespawn        #/MATA
	KillAllNearbyNPCs       #/MASSKILL
	LastIP                  #/LASTIP
	ChangeMOTD              #/MOTDCAMBIA
	SetMOTD                 #ZMOTD
	SystemMessage           #/SMSG
	CreateNPC               #/ACC
	CreateNPCWithRespawn    #/RACC
	ImperialArmour          #/AI1 - 4
	ChaosArmour             #/AC1 - 4
	NavigateToggle          #/NAVE
	ServerOpenToUsersToggle #/HABILITAR
	TurnOffServer           #/APAGAR
	TurnCriminal            #/CONDEN
	ResetFactions           #/RAJAR
	RemoveCharFromGuild     #/RAJARCLAN
	RequestCharMail         #/LASTEMAIL
	AlterPassword           #/APASS
	AlterMail               #/AEMAIL
	AlterName               #/ANAME
	ToggleCentinelActivated #/CENTINELAACTIVADO
	DoBackUp                #/DOBACKUP
	ShowGuildMessages       #/SHOWCMSG
	SaveMap                 #/GUARDAMAPA
	ChangeMapInfoPK         #/MODMAPINFO PK
	ChangeMapInfoBackup     #/MODMAPINFO BACKUP
	ChangeMapInfoRestricted #/MODMAPINFO RESTRINGIR
	ChangeMapInfoNoMagic    #/MODMAPINFO MAGIASINEFECTO
	ChangeMapInfoNoInvi     #/MODMAPINFO INVISINEFECTO
	ChangeMapInfoNoResu     #/MODMAPINFO RESUSINEFECTO
	ChangeMapInfoLand       #/MODMAPINFO TERRENO
	ChangeMapInfoZone       #/MODMAPINFO ZONA
	SaveChars               #/GRABAR
	CleanSOS                #/BORRAR SOS
	ShowServerForm          #/SHOW INT
	night                   #/NOCHE
	KickAllChars            #/ECHARTODOSPJS
	RequestTCPStats         #/TCPESSTATS
	ReloadNPCs              #/RELOADNPCS
	ReloadServerIni         #/RELOADSINI
	ReloadSpells            #/RELOADHECHIZOS
	ReloadObjects           #/RELOADOBJ
	Restart                 #/REINICIAR
	ResetAutoUpdate         #/AUTOUPDATE
	ChatColor               #/CHATCOLOR
	Ignored                 #/IGNORADO
	CheckSlot               #/SLOT
}


var auxiliarBuffer:StreamPeerBuffer
var _handlers = {}


func _init():
	auxiliarBuffer = ByteQueue.new()
	
	_init_handlers()
	
func _init_handlers():
	_handlers[ServerPacketID.ErrorMsg] = "_handle_error_msg"
	_handlers[ServerPacketID.Logged] = "_handle_logged"
	_handlers[ServerPacketID.RemoveCharDialog] = "_handle_remove_char_dialog"
	_handlers[ServerPacketID.ResuscitationSafeOff] = "_handle_resuscitation_safe_off"
	_handlers[ServerPacketID.ResuscitationSafeOn] = "_handle_resuscitation_safe_on"
	_handlers[ServerPacketID.ChangeInventorySlot] = "_handle_change_inventory_slot"
	_handlers[ServerPacketID.ChangeSpellSlot] = "_handle_change_spell_slot"
	_handlers[ServerPacketID.DumbNoMore] = "_handle_dumb_no_more"
	_handlers[ServerPacketID.UserIndexInServer] = "_handle_user_index_in_server"
	_handlers[ServerPacketID.ChangeMap] = "_handle_change_map"
	_handlers[ServerPacketID.PlayMidi] = "_handle_play_midi"
	_handlers[ServerPacketID.AreaChanged] = "_handle_area_changed"	
	_handlers[ServerPacketID.ObjectCreate] = "_handle_object_create"
	_handlers[ServerPacketID.BlockPosition] = "_handle_block_position"
	_handlers[ServerPacketID.CharacterCreate] =  "_handle_character_create"
	_handlers[ServerPacketID.CreateFX] =  "_handle_create_fx"
	_handlers[ServerPacketID.UserCharIndexInServer] = "_handle_char_index_in_server"
	_handlers[ServerPacketID.UpdateUserStats] = "_handle_update_user_stats"
	_handlers[ServerPacketID.UpdateHungerAndThirst] = "_handle_update_hunger_and_thirst"
	_handlers[ServerPacketID.GuildChat] = "_handle_guild_chat"
	_handlers[ServerPacketID.SafeModeOn] = "_handle_safe_mode_on"
	_handlers[ServerPacketID.SafeModeOff] = "_handle_safe_mode_off"
	_handlers[ServerPacketID.DiceRoll] = "_handle_dice_roll"
	_handlers[ServerPacketID.PlayWave] = "_handle_play_wave"
	_handlers[ServerPacketID.RainToggle] = "_handle_tain_toggle"
	_handlers[ServerPacketID.ConsoleMsg] = "_handle_console_msg"
	_handlers[ServerPacketID.ShowMessageBox] = "_handle_show_message_box"
	_handlers[ServerPacketID.CharacterMove] = "_handle_character_move"
	_handlers[ServerPacketID.UpdateSta] = "_handle_update_sta"
	_handlers[ServerPacketID.ChatOverHead] = "_handle_chat_over_head"
	_handlers[ServerPacketID.CharacterChange] = "_handle_character_change"
	_handlers[ServerPacketID.CharacterRemove] = "_handle_character_remove"
	_handlers[ServerPacketID.PauseToggle] = "_handle_pause_toggle" 
	_handlers[ServerPacketID.PosUpdate] = "_handle_pos_update"
	_handlers[ServerPacketID.RemoveDialogs] = "_handle_remove_dialogs"
	_handlers[ServerPacketID.SendSkills]  = "_handle_send_skills"
	_handlers[ServerPacketID.Disconnect] = "_handle_disconnect"
	_handlers[ServerPacketID.ObjectDelete] = "_handle_object_delete"
	_handlers[ServerPacketID.UpdateHP] = "_handle_update_hp"
	_handlers[ServerPacketID.NPCHitUser] = "_handle_npc_hit_user"
	_handlers[ServerPacketID.UserHitNPC] = "_handle_user_hit_npc"
	_handlers[ServerPacketID.UserSwing] = "_handle_user_swing"
	_handlers[ServerPacketID.NPCSwing] = "_handle_npc_swing" 
	_handlers[ServerPacketID.UpdateGold] = "_handle_update_gold" 
	_handlers[ServerPacketID.WorkRequestTarget] = "_handle_work_request_target"
	_handlers[ServerPacketID.NPCKillUser] = "_handle_npc_kill_user"
	_handlers[ServerPacketID.UpdateTagAndStatus] = "_handle_update_tag_and_status"
	_handlers[ServerPacketID.SetInvisible] = "_handle_set_invisible"
	_handlers[ServerPacketID.UserAttackedSwing] = "_handle_user_attacked_swing"
	_handlers[ServerPacketID.UserHittedByUser] = "_handle_user_hitted_by_user"

func handle_incoming_data(bytes):
	var buffer = ByteQueue.new()
	buffer.data_array = bytes
	
	while(buffer.get_position() < buffer.get_size()):
		var packet_id = buffer.get_u8()
		if _handlers.has(packet_id):
			var handler = _handlers.get(packet_id)
			var data = call(handler, buffer)
			emit_signal("parse_data", packet_id, data) 
		else:
			print("paquete con un id invalido: %d" % packet_id )
			Connection.disconnect_from_server()
			break
	 
############################################### INICIO DE HANDLERS ##########################################################################
func _handle_user_hitted_by_user(buffer:StreamPeer) -> Dictionary:
	var data = {}
	data.attacker = buffer.get_16()
	data.case = buffer.get_u8()
	data.damage = buffer.get_16()
	
	return data

func _handle_user_attacked_swing(buffer:StreamPeer) -> int:
	return buffer.get_16()
	
func _handle_set_invisible(buffer:StreamPeer) -> Dictionary:
	var data = {}
	data.char_id = buffer.get_16()
	data.invisible = buffer.get_u8()
	
	return data

func _handle_update_tag_and_status(buffer:StreamPeer) -> Dictionary:
	var data = {}
	data.char_id = buffer.get_16()
	data.criminal = buffer.get_u8()
	data.userTag = buffer.get_utf8_string() 
	return data

func _handle_work_request_target(data:StreamPeer) -> int:
	return data.get_u8()

func _handle_update_gold(data:StreamPeer) -> int:
	return data.get_32()

func _handle_user_swing(_buffer):
	return
	
func _handle_npc_swing(_buffer):
	return

func _handle_user_hit_npc(buffer:StreamPeerBuffer) -> int:
	return buffer.get_32()

func _handle_error_msg(buffer:StreamPeerBuffer): 
	emit_signal("error_message", buffer.get_utf8_string())
	
func _handle_logged(_buffer:StreamPeerBuffer):
	emit_signal("logged")
	
func _handle_resuscitation_safe_off(_buffer:StreamPeerBuffer):
	pass
	
func _handle_resuscitation_safe_on(_buffer:StreamPeerBuffer):
	pass

func _handle_change_inventory_slot(buffer:StreamPeerBuffer) -> Dictionary:
	var data = {}
	 
	data.slot = buffer.get_u8()
	data.obj_index = buffer.get_16()
	data.name = buffer.get_utf8_string()
	data.amount = buffer.get_16()
	data.equipped = buffer.get_u8()
	data.grh_index = buffer.get_16()
	data.obj_type = buffer.get_u8()
	data.max_hit = buffer.get_16()
	data.min_hit = buffer.get_16()
	data.defense = buffer.get_16()
	data.value = buffer.get_float()
	
	return data 
	
func _handle_change_spell_slot(buffer:StreamPeerBuffer) -> Dictionary:
	var data = {}
	
	data.slot = buffer.get_u8()
	data.spell_id = buffer.get_16()
	data.spell_name = buffer.get_utf8_string()
	
	return data
	
func _handle_dumb_no_more(_buffer:StreamPeerBuffer):
	pass
	 
func _handle_user_index_in_server(buffer:StreamPeerBuffer) -> int:
	return buffer.get_16()
 
func _handle_change_map(buffer:StreamPeerBuffer) -> Dictionary:
	var data = {}
	
	data.map_id = buffer.get_16()
	data.version = buffer.get_16() #no se usa
	
	return data

func _handle_play_midi(buffer:StreamPeerBuffer) -> Dictionary:
	var data = {}

	data.midi = buffer.get_u8()
	data.loops = buffer.get_16()
	 
	return data
	
func _handle_area_changed(buffer:StreamPeerBuffer) -> Dictionary:
	var data = {}	

	data.x = buffer.get_u8()
	data.y = buffer.get_u8()
	
	return data 
	
func _handle_object_create(buffer:StreamPeerBuffer) -> Dictionary:
	var data = {}	
	
	data.x = buffer.get_u8()
	data.y = buffer.get_u8()
	data.grh_index = buffer.get_16()

	return data 

func _handle_block_position(buffer:StreamPeerBuffer) -> Dictionary:
	var data = {}		

	data.x = buffer.get_u8()
	data.y = buffer.get_u8()
	data.value = buffer.get_u8()	
	
	return data 
	
func _handle_character_create(buffer:StreamPeerBuffer) -> Dictionary:
	var data = {}
	
	data.char_id = buffer.get_16()
	data.body = buffer.get_16()
	data.head = buffer.get_16()
	data.heading = buffer.get_u8()
	data.x = buffer.get_u8()
	data.y = buffer.get_u8()
	data.weapon = buffer.get_16()
	data.shield = buffer.get_16()
	data.helmet = buffer.get_16()
	data.fx = buffer.get_16()
	data.fx_loop = buffer.get_16()
	data.name = buffer.get_utf8_string()
	data.criminal = buffer.get_u8()
	data.privs = buffer.get_u8()
	
	return data
	
func _handle_create_fx(buffer:StreamPeerBuffer) -> Dictionary:
	var data = {}
	
	data.char_id = buffer.get_16()
	data.fx = buffer.get_16()
	data.fx_loop = buffer.get_16()
	
	return data

func _handle_char_index_in_server(buffer:StreamPeerBuffer) -> int:
	return buffer.get_16()
	
func _handle_update_user_stats(buffer:StreamPeerBuffer) -> Dictionary:
	var data = {}
	
	data.max_hp = buffer.get_16()
	data.min_hp = buffer.get_16()
	data.max_mp = buffer.get_16()
	data.min_mp = buffer.get_16()
	data.max_sta = buffer.get_16()
	data.min_sta = buffer.get_16()
	data.gold = buffer.get_32()
	data.lvl = buffer.get_u8()
	data.elu = buffer.get_32()
	data.u_lvl = buffer.get_32()
	
	return data 
	
func _handle_update_hunger_and_thirst(buffer:StreamPeerBuffer) -> Dictionary:
	var data = {}
		
	data.max_agua = buffer.get_u8()
	data.min_agua = buffer.get_u8()
	data.max_ham = buffer.get_u8()
	data.min_ham = buffer.get_u8()
	
	return data
	
func _handle_guild_chat(buffer:StreamPeerBuffer) -> String:
	return buffer.get_utf8_string()
	
func _handle_safe_mode_on(_buffer:StreamPeerBuffer): 
	pass
	
func _handle_safe_mode_off(_buffer:StreamPeerBuffer): 
	pass
	
func _handle_dice_roll(buffer:StreamPeerBuffer) -> Array:
	var data = [] 
	
	for _i in range(Global.NUMATRIBUTOS):
		data.append(buffer.get_u8())
		
	return data 
	
func _handle_play_wave(buffer:StreamPeerBuffer) -> Dictionary:
	var data = {}

	data.wave = buffer.get_u8()
	data.x = buffer.get_u8()
	data.y = buffer.get_u8()
	
	return data 
	
func _handle_tain_toggle(_buffer:StreamPeerBuffer):
	pass
	
func _handle_console_msg(buffer:StreamPeerBuffer) -> Dictionary:
	var data = {}
	
	data.message = buffer.get_utf8_string()
	data.font_id = buffer.get_u8()
	
	return data	
	
func _handle_show_message_box(buffer:StreamPeerBuffer) -> String:
	return buffer.get_utf8_string()
	
func _handle_character_move(buffer:StreamPeerBuffer) -> Dictionary:
	var data = {}
	
	data.char_id = buffer.get_16()
	data.x = buffer.get_u8()
	data.y = buffer.get_u8()
	
	return data
	
func _handle_update_sta(buffer:StreamPeerBuffer) -> int:
	return buffer.get_16()
	
func _handle_chat_over_head(buffer:StreamPeerBuffer) -> Dictionary:
	var data = {}
	
	data.message = buffer.get_utf8_string()
	data.char_id = buffer.get_16()
	data.color = Color(buffer.get_u8() / 255, buffer.get_u8() / 255, buffer.get_u8() / 255, 1)
	
	return data;
	
func _handle_character_change(buffer:StreamPeerBuffer) -> Dictionary:
	var data = {}
	
	data.char_id = buffer.get_16()
	data.body = buffer.get_16()
	data.head = buffer.get_16()
	data.heading = buffer.get_u8()
	data.weapon = buffer.get_16()
	data.shield = buffer.get_16()
	data.helmet = buffer.get_16()
	data.fx = buffer.get_16()
	data.fx_loop = buffer.get_16()
	
	return data
	
func _handle_remove_char_dialog(buffer:StreamPeerBuffer) -> int:
	return buffer.get_16()
	
func _handle_character_remove(buffer:StreamPeerBuffer) -> int:
	return buffer.get_16()
	
func _handle_pause_toggle(_buffer:StreamPeerBuffer):
	pass
	
func _handle_pos_update(buffer:StreamPeerBuffer) -> Dictionary:
	var data = {}
	data.x = buffer.get_u8()
	data.y = buffer.get_u8()
	
	return data

func _handle_remove_dialogs(_buffer):
	pass
	
func _handle_send_skills(buffer:StreamPeerBuffer) -> Array:
	var skills = []
	
	for i in range(Global.MAXSKILLPOINTS):
		skills.append(buffer.get_u8())
		
	return skills 
	
func _handle_disconnect(_buffer):
	return
	
func _handle_object_delete(buffer:StreamPeerBuffer) -> Dictionary:
	var data = {}
	
	data.x = buffer.get_u8()
	data.y = buffer.get_u8()
	
	return data

func _handle_update_hp(buffer:StreamPeerBuffer) -> int:
	return buffer.get_16()	
	
func _handle_npc_hit_user(buffer:StreamPeerBuffer) -> int:
	return buffer.get_16()
	
func _handle_npc_kill_user(_buff):
	pass

############################################### FIN DE HANDLERS ##########################################################################


############################################### INICIO DE WRITERS  ##########################################################################
func write_login_existing_char(user_name:String, user_password:String):
	auxiliarBuffer.put_u8(ClientPacketID.LoginExistingChar)
	auxiliarBuffer.put_utf8_string(user_name)
	auxiliarBuffer.put_utf8_string(user_password)
	
	auxiliarBuffer.put_u8(0)
	auxiliarBuffer.put_u8(12)
	auxiliarBuffer.put_u8(1)
	  
	for _i in range(7):
		auxiliarBuffer.put_16(0)
		
func write_login_new_char(user_name:String, user_password:String, user_race:int, user_gender:int, user_class:int,user_email:String, user_home:int, skills:Array):
	auxiliarBuffer.put_u8(ClientPacketID.LoginNewChar)
	auxiliarBuffer.put_utf8_string(user_name)
	auxiliarBuffer.put_utf8_string(user_password)
	
	auxiliarBuffer.put_u8(0)
	auxiliarBuffer.put_u8(12)
	auxiliarBuffer.put_u8(1)
	  
	for _i in range(7):
		auxiliarBuffer.put_16(0)
		
	auxiliarBuffer.put_u8(user_race)
	auxiliarBuffer.put_u8(user_gender)
	auxiliarBuffer.put_u8(user_class)
	
	for skill in skills:
		auxiliarBuffer.put_u8(skill)
	
	auxiliarBuffer.put_utf8_string(user_email)
	auxiliarBuffer.put_u8(user_home)
		

func write_throw_dices():
	auxiliarBuffer.put_u8(ClientPacketID.ThrowDices)
	
func write_walk(heading:int) -> void:
	auxiliarBuffer.put_u8(ClientPacketID.Walk)
	auxiliarBuffer.put_u8(heading)
	
func write_change_heading(heading:int) -> void:
	auxiliarBuffer.put_u8(ClientPacketID.ChangeHeading)
	auxiliarBuffer.put_u8(heading)
	
func write_attack():
	auxiliarBuffer.put_u8(ClientPacketID.Attack)
	
func write_combat_mode_toggle():
	auxiliarBuffer.put_u8(ClientPacketID.CombatModeToggle)
	
func write_pick_up():
	auxiliarBuffer.put_u8(ClientPacketID.PickUp)
	
func write_move_sell(upwards:bool, slot:int):
	auxiliarBuffer.put_u8(ClientPacketID.MoveSpell)
	auxiliarBuffer.put_u8(upwards)
	auxiliarBuffer.put_u8(slot)
	
func write_use_item(slot:int):
	auxiliarBuffer.put_u8(ClientPacketID.UseItem)
	auxiliarBuffer.put_u8(slot)
	
func write_left_click(x:int, y:int):
	auxiliarBuffer.put_u8(ClientPacketID.LeftClick)
	auxiliarBuffer.put_u8(x)
	auxiliarBuffer.put_u8(y)
	
func write_double_click(x:int, y:int):
	auxiliarBuffer.put_u8(ClientPacketID.DoubleClick)
	auxiliarBuffer.put_u8(x)
	auxiliarBuffer.put_u8(y)
	
func write_work(skill:int):
	auxiliarBuffer.put_u8(ClientPacketID.Work)
	auxiliarBuffer.put_u8(skill) 
	
func write_cast_spell(slot:int):
	auxiliarBuffer.put_u8(ClientPacketID.CastSpell)
	auxiliarBuffer.put_u8(slot) 
	
func write_spell_info(slot:int):
	auxiliarBuffer.put_u8(ClientPacketID.SpellInfo)
	auxiliarBuffer.put_u8(slot) 

func write_equip_item(slot:int):
	auxiliarBuffer.put_u8(ClientPacketID.EquipItem)
	auxiliarBuffer.put_u8(slot) 
	
func write_talk(chat:String):
	auxiliarBuffer.put_u8(ClientPacketID.Talk)
	auxiliarBuffer.put_utf8_string(chat) 
	
func write_quit():
	auxiliarBuffer.put_u8(ClientPacketID.Quit)	

func write_work_left_click(x:int, y:int, skill:int):
	auxiliarBuffer.put_u8(ClientPacketID.WorkLeftClick)
	auxiliarBuffer.put_u8(x)
	auxiliarBuffer.put_u8(y)
	auxiliarBuffer.put_u8(skill)
############################################### FIN DE WRITERS ##########################################################################
 

func flush_data():
	if(auxiliarBuffer.get_size() > 0):
		Connection.send_data(auxiliarBuffer.data_array)
		auxiliarBuffer = ByteQueue.new()
