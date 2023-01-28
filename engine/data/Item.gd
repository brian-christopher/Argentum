extends Resource
class_name Item

var name:String = "" 
var texture:Texture = null
var type:int = 0
var min_hit:int = 0
var max_hit:int = 0
var defense:int = 0
var value:int = 0 

enum eObjType{
	None = 0
	otUseOnce = 1
	otWeapon = 2
	otArmadura = 3
	otArboles = 4
	otGuita = 5
	otPuertas = 6
	otContenedores = 7
	otCarteles = 8
	otLlaves = 9
	otForos = 10
	otPociones = 11
	otBebidas = 13
	otLena = 14
	otFogata = 15
	otESCUDO = 16
	otCASCO = 17
	otAnillo = 18
	otTeleport = 19
	otYacimiento = 22
	otMinerales = 23
	otPergaminos = 24
	otInstrumentos = 26
	otYunque = 27
	otFragua = 28
	otBarcos = 31
	otFlechas = 32
	otBotellaVacia = 33
	otBotellaLlena = 34
	otManchas = 35          #No se usa
	otCualquiera = 1000
}
 
func is_equippable() -> bool:
	return type in [eObjType.otArmadura,eObjType.otWeapon,eObjType.otESCUDO,eObjType.otCASCO,eObjType.otAnillo, eObjType.otInstrumentos, eObjType.otFlechas, eObjType.otBarcos]

func is_consumable() -> bool:
	return type in [eObjType.otGuita, eObjType.otLlaves, eObjType.otPociones, eObjType.otBebidas, eObjType.otPergaminos]
