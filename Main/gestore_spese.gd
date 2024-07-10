extends Control
const LINE_CHART = preload("res://Main/LineChart.tscn")
const PIE_CHART = preload("res://Main/PieChart.tscn")
const BAR_CHART = preload("res://Main/BarChart.tscn")


@onready var SETTINGS_PATH = "user://settings.tres"
@export var DatabasePath = "user://database.db"
var AnnoCorrente : int
var MeseCorrente : int
var GiornoCorrente : int

var AnnoSelezionato : int
var MeseSelezionato : int
var GiornoSelezionato : int

var AnnoPlaceholder : int

var OrdineDate : bool = false

var database : SQLite
const Table : String = "spese"

var BilancioAnnualePerMesi : Array[float] = [0,0,0,0,0,0,0,0,0,0,0,0]
var EntrataAnnualePerMesi : Array[float] = [0,0,0,0,0,0,0,0,0,0,0,0]
var UscitaAnnualePerMesi : Array[float] = [0,0,0,0,0,0,0,0,0,0,0,0]

var RetribuzioneAnnualePerMesi : Array[float] = [0,0,0,0,0,0,0,0,0,0,0,0]
var LavoroAnnualePerMesi : Array[float] = [0,0,0,0,0,0,0,0,0,0,0,0]
var AlimentariAnnualePerMesi : Array[float] = [0,0,0,0,0,0,0,0,0,0,0,0]
var SvagoAnnualePerMesi : Array[float] = [0,0,0,0,0,0,0,0,0,0,0,0]
var ImmobiliAnnualePerMesi : Array[float] = [0,0,0,0,0,0,0,0,0,0,0,0]
var ArredamentoAnnualePerMesi : Array[float] = [0,0,0,0,0,0,0,0,0,0,0,0]
var StudioAnnualePerMesi : Array[float] = [0,0,0,0,0,0,0,0,0,0,0,0]
var TasseAnnualePerMesi : Array[float] = [0,0,0,0,0,0,0,0,0,0,0,0]
var VeicoliAnnualePerMesi : Array[float] = [0,0,0,0,0,0,0,0,0,0,0,0]
var AltreSpeseAnnualePerMesi : Array[float] = [0,0,0,0,0,0,0,0,0,0,0,0]

var RetribuzioneAnnuale : float = 0
var LavoroAnnuale : float = 0
var AlimentariAnnuale : float = 0
var SvagoAnnuale : float = 0
var ImmobiliAnnuale : float = 0
var ArredamentoAnnuale : float = 0
var StudioAnnuale : float = 0
var TasseAnnuale : float = 0
var VeicoliAnnuale : float = 0
var AltreSpeseAnnuale : float = 0
var GeneriTotali : float = 0



func _ready() -> void:
	for i in range(1945,2251):
		($ChooseDate/DateOption as OptionButton).add_item(str(i),i)
	for i in range(1,32):
		($Form/Data/Data/GG as OptionButton).add_item(str(i),i)
	for i in range(1,13):
		($Form/Data/Data/MM as OptionButton).add_item(str(i),i)
	for i in range(1945,2251):
		($Form/Data/Data/AAAA as OptionButton).add_item(str(i),i)
	($Form/Data/Data/GG as OptionButton).selected=0
	($Form/Data/Data/MM as OptionButton).selected=0
	($Form/Data/Data/AAAA as OptionButton).selected=0
	
	if FileAccess.file_exists(DatabasePath):
		database = SQLite.new()
		database.path = DatabasePath
		database.open_db()
	else:
		create_file_in_directory(DatabasePath)
		database = SQLite.new()
		database.path = DatabasePath
		database.open_db()
		var table = {
		"ID" : {"data_type" : "INTEGER","primary_key" : true,"not_null" : true,"auto_increment" : true},
		"Nome" : {"data_type" : "CHAR"},
		"Importo" : {"data_type" : "REAL"},
		"Entrata" : {"data_type" : "BOOL"},
		"Tipologia" : {"data_type" : "INTEGER"},
		"Data" : {"data_type" : "DATE"}
	}
		database.create_table("spese", table)
	
	var DataDict = Time.get_datetime_dict_from_system()
	AnnoCorrente = DataDict["year"]
	MeseCorrente = DataDict["month"]
	GiornoCorrente = DataDict["day"]
	$CurrentDate/DataCorrente.text = "[p align=center]Data corrente: " + str(GiornoCorrente) + " [b]/[/b] " + str(MeseCorrente) + " [b]/[/b] " + str(AnnoCorrente) + "[/p]"
	
	AnnoSelezionato = AnnoCorrente
	AnnoPlaceholder = AnnoCorrente
	MeseSelezionato = MeseCorrente
	GiornoSelezionato = GiornoCorrente
	
	update_charts()
	update_history()
	
	($ChooseDate/DateOption as OptionButton).select(AnnoCorrente-1945)
	($ChooseDate/DateOption as OptionButton).selected = AnnoCorrente-1945
	($Background/Dropdown as MenuButton).get_popup().connect("id_pressed", _on_item_pressed)
	
	if !FileAccess.file_exists(SETTINGS_PATH):
		var NewSettings = Settings.new()
		(NewSettings as Settings).BG_PATH = ""
		ResourceSaver.save(NewSettings,SETTINGS_PATH)
	else:
		var OldSettings = ResourceLoader.load(SETTINGS_PATH)
		if OldSettings != null:
			load_bg_from_path((OldSettings as Settings).BG_PATH)
		else:
			print("Impostazioni non trovate")

func create_file_in_directory(FilePath : String) -> void:
	#Use FilePath to know both where to put the file and the name of the file itself.
	#NOTE that this function will only create an empty file at the designed location with the
	#specified name, it won't save any data.
	var file = FileAccess.open(FilePath, FileAccess.WRITE_READ)
	file.close()

func _process(delta: float) -> void:
	
	
	match $Charts/OptionButton.selected:
			0:
				$Charts/LineChart/Graph2D.x_label = "Anno \""+str(AnnoSelezionato)+"\"" 
			
			1:
				$Charts/PieChart/RichTextLabel/Label.text =  "Anno: \""+str(AnnoSelezionato)+"\""
			
			2:
				pass
			
			3:
				pass

func _on_insert_button_pressed() -> void:
	#region Get Data
	var Nome : String = $Form/Nome/TextEdit.text
	var Importo : float = float($Form/Importo/TextEdit.text)
	var Entrata : bool = $Form/Tipologia/RatioBox.Entrata
	var Genere : int = $Form/Genere/DropDown.selected
	var GiornoData : String = $Form/Data/Data/GG.text
	var MeseData : String = $Form/Data/Data/MM.text
	var AnnoData : String = $Form/Data/Data/AAAA.text
	var DataCompleta : String = AnnoData + "-" + MeseData + "-" + GiornoData
	#endregion
	if Nome == null or Nome == "":
		push_error("FIELD ERROR: Invalid name")
	elif Importo == null or Importo == 0:
		push_error("FIELD ERROR: Invalid import")
	elif Genere == -1:
		push_error("FIELD ERROR: Invalid type")
	else:
		#region Reset fields
		$Form/Nome/TextEdit.text = ""
		$Form/Importo/TextEdit.text = ""
		$Form/Genere/DropDown.selected = 0
		$Form/Data/Data/GG.selected = 0
		$Form/Data/Data/MM.selected = 0
		$Form/Data/Data/AAAA.selected = 0
		#endregion
		var Row : Dictionary = {"Nome" : Nome,"Importo" : Importo,"Entrata" : Entrata,"Tipologia" : Genere,"Data" : DataCompleta,}
		database.insert_row(Table,Row)
		print("SUCCESSFULLY ADDED ELEMENT \"" + Nome + "\" to \"" + Table + "\" table")
	
	update_charts()
	update_history()

func get_dati_annuali_per_mesi(Anno : int = AnnoCorrente) -> void:
	BilancioAnnualePerMesi = [0,0,0,0,0,0,0,0,0,0,0,0]
	UscitaAnnualePerMesi = [0,0,0,0,0,0,0,0,0,0,0,0]
	EntrataAnnualePerMesi = [0,0,0,0,0,0,0,0,0,0,0,0]
	#print("CALCOLO SOMME ANNUALI PER ENTRATE, USCITE E BILANCIO\n")
	#print("\nESEGUO QUERY\n")
	var query = "SELECT Importo, Entrata, Data FROM spese WHERE strftime('%Y', Data) = '" + str(AnnoSelezionato) + "';"
	database.query(query)
	#print("\nCICLO NEI RISULTATI DELLA QUERY\n")
	var index : int = 1
	for result in database.query_result:
		#print("\n\nRISULTATO NUMERO: " + str(index))
		index += 1
		var ImportoParziale = result["Importo"]
		var TipoImporto : float = 0
		var DataTotale : String = result["Data"]
		var DataDivisa = DataTotale.split("-")
		var Mese = DataDivisa[1]
		#print("MESE RISULTATO: " + Mese)
		#print("IMPORTO RISULTATO: " + str(ImportoParziale))
		match result["Entrata"]:
			true:
				TipoImporto = 1
			false:
				TipoImporto = -1
			1:
				TipoImporto = 1
			0:
				TipoImporto = -1
			_:
				push_error("NONEXISTANT IMPORT TYPE")
				TipoImporto = 0
		#print("TIPO IMPORTO RISULTATO: " + str(TipoImporto))
		var BilancioFinale : float = ImportoParziale * TipoImporto
		#print("BILANCIO FINALE RISULTATO: " + str(BilancioFinale))
		match Mese:
			"01":
				if TipoImporto == 1:
					EntrataAnnualePerMesi[0] += ImportoParziale
				elif TipoImporto == -1:
					UscitaAnnualePerMesi[0] += ImportoParziale
				else:
					print("ERROR69420")
			"02":
				if TipoImporto == 1:
					EntrataAnnualePerMesi[1] += ImportoParziale
				elif TipoImporto == -1:
					UscitaAnnualePerMesi[1] += ImportoParziale
				else:
					print("ERROR69420")
			"03":
				if TipoImporto == 1:
					EntrataAnnualePerMesi[2] += ImportoParziale
				elif TipoImporto == -1:
					UscitaAnnualePerMesi[2] += ImportoParziale
				else:
					print("ERROR69420")
			"04":
				if TipoImporto == 1:
					EntrataAnnualePerMesi[3] += ImportoParziale
				elif TipoImporto == -1:
					UscitaAnnualePerMesi[3] += ImportoParziale
				else:
					print("ERROR69420")
			"05":
				if TipoImporto == 1:
					EntrataAnnualePerMesi[4] += ImportoParziale
				elif TipoImporto == -1:
					UscitaAnnualePerMesi[4] += ImportoParziale
				else:
					print("ERROR69420")
			"06":
				if TipoImporto == 1:
					EntrataAnnualePerMesi[5] += ImportoParziale
				elif TipoImporto == -1:
					UscitaAnnualePerMesi[5] += ImportoParziale
				else:
					print("ERROR69420")
			"07":
				if TipoImporto == 1:
					EntrataAnnualePerMesi[6] += ImportoParziale
				elif TipoImporto == -1:
					UscitaAnnualePerMesi[6] += ImportoParziale
				else:
					print("ERROR69420")
			"08":
				if TipoImporto == 1:
					EntrataAnnualePerMesi[7] += ImportoParziale
				elif TipoImporto == -1:
					UscitaAnnualePerMesi[7] += ImportoParziale
				else:
					print("ERROR69420")
			"09":
				if TipoImporto == 1:
					EntrataAnnualePerMesi[8] += ImportoParziale
				elif TipoImporto == -1:
					UscitaAnnualePerMesi[8] += ImportoParziale
				else:
					print("ERROR69420")
			"10":
				if TipoImporto == 1:
					EntrataAnnualePerMesi[9] += ImportoParziale
				elif TipoImporto == -1:
					UscitaAnnualePerMesi[9] += ImportoParziale
				else:
					print("ERROR69420")
			"11":
				if TipoImporto == 1:
					EntrataAnnualePerMesi[10] += ImportoParziale
				elif TipoImporto == -1:
					UscitaAnnualePerMesi[10] += ImportoParziale
				else:
					print("ERROR69420")
			"12":
				if TipoImporto == 1:
					EntrataAnnualePerMesi[11] += ImportoParziale
				elif TipoImporto == -1:
					UscitaAnnualePerMesi[11] += ImportoParziale
				else:
					print("ERROR69420")
	
	for i in range(0,12):
		if i == 0:
			BilancioAnnualePerMesi[i] = EntrataAnnualePerMesi[i]-UscitaAnnualePerMesi[i]
		else:
			BilancioAnnualePerMesi[i] = BilancioAnnualePerMesi[i-1]+(EntrataAnnualePerMesi[i]-UscitaAnnualePerMesi[i])

func get_generi_annuali(Anno : int = AnnoCorrente) -> void:
	RetribuzioneAnnuale = 0
	LavoroAnnuale = 0
	AlimentariAnnuale = 0
	SvagoAnnuale = 0
	ImmobiliAnnuale = 0
	ArredamentoAnnuale = 0
	StudioAnnuale = 0
	TasseAnnuale = 0
	VeicoliAnnuale = 0
	AltreSpeseAnnuale = 0 
	GeneriTotali = 0
	#print("\nCALCOLO SOMME ANNUALI DIVISE PER GENERI\n")
	#print("\nESEGUO QUERY\n")
	database.query("SELECT Importo, Tipologia FROM spese WHERE strftime('%Y', Data) = '"+str(AnnoSelezionato)+"'")
	for result in database.query_result:
		#print("\nCICLO NEI RISULTATI DELLA QUERY\n")
		match result["Tipologia"]:
			0:
				#print("\nCALCOLO RETRIBUZIONE\n")
				RetribuzioneAnnuale += result["Importo"]
			
			1:
				#print("\nCALCOLO LAVORI\n")
				LavoroAnnuale += result["Importo"]
			
			2:
				#print("\nCALCOLO ALIMENTARI\n")
				AlimentariAnnuale += result["Importo"]
			
			3:
				#print("\nCALCOLO SVAGO\n")
				SvagoAnnuale += result["Importo"]
			
			4:
				#print("\nCALCOLO IMMOBILI\n")
				ImmobiliAnnuale += result["Importo"]
			
			5:
				#print("\nCALCOLO ARREDAMENTO\n")
				ArredamentoAnnuale += result["Importo"]
			
			6:
				#print("\nCALCOLO STUDIO\n")
				StudioAnnuale += result["Importo"]
			
			7:
				#print("\nCALCOLO TASSE\n")
				TasseAnnuale += result["Importo"]
			
			8:
				#print("\nCALCOLO VEICOLI\n")
				VeicoliAnnuale += result["Importo"]
			
			9:
				#print("\nCALCOLO ALTRE SPESE\n")
				AltreSpeseAnnuale += result["Importo"]
		GeneriTotali = RetribuzioneAnnuale+LavoroAnnuale+AlimentariAnnuale+SvagoAnnuale+ImmobiliAnnuale+ArredamentoAnnuale+StudioAnnuale+TasseAnnuale+VeicoliAnnuale+AltreSpeseAnnuale

func is_bisestile(AnnoDaControllare : int):
	var AnnoInteressato = float(AnnoDaControllare)
	if (AnnoInteressato % 4 == 0 and AnnoInteressato % 100 != 0) or (AnnoInteressato %400 == 0):
		return true
	else:
		return false

func _on_option_button_item_selected(index: int) -> void:
	match index:
		0:
			var CurrentChart = ($Charts.get_children() as Array).back()
			CurrentChart.queue_free()
			var NewChart = LINE_CHART.instantiate()
			$Charts.add_child(NewChart)
			update_charts()
		
		1:
			#print("\nGENERAZIONE GRAFICO A TORTA\n")
			var CurrentChart = ($Charts.get_children() as Array).back()
			CurrentChart.queue_free()
			var NewChart = PIE_CHART.instantiate()
			$Charts.add_child(NewChart)
			get_generi_annuali()
			update_charts()
		
		2:
			var CurrentChart = ($Charts.get_children() as Array).back()
			CurrentChart.queue_free()
			var NewChart = BAR_CHART.instantiate()
			$Charts.add_child(NewChart)
			update_charts()
		
		3:
			var CurrentChart = ($Charts.get_children() as Array).back()
			CurrentChart.queue_free()
			var NewChart = LINE_CHART.instantiate()
			$Charts.add_child(NewChart)
			update_charts()
		
		_:
			push_error("NONEXISTANT CHART TYPE")

func update_charts() -> void:
	match $Charts/OptionButton.selected:
			0:
				($Charts/LineChart/Graph2D as Graph2D).remove_all()
				get_dati_annuali_per_mesi(AnnoCorrente)
				var index : int = 0
				
				var MaxBilancio : float = BilancioAnnualePerMesi.max()
				var MinBilancio : float = BilancioAnnualePerMesi.min()
				var MaxEntrata : float = EntrataAnnualePerMesi.max()
				var MinEntrata : float = EntrataAnnualePerMesi.min()
				var MaxUscita : float = UscitaAnnualePerMesi.max()
				var MinUscita : float = UscitaAnnualePerMesi.min()
				var MaxArray : Array[float] = [MaxBilancio,MaxEntrata,MaxUscita]
				var MinArray : Array[float] = [MinBilancio,MinEntrata,MinUscita]
				var MaxValue : float = MaxArray.max()
				var MinValue : float = MinArray.min()
				
				($Charts/LineChart/Graph2D as Graph2D).y_min = MinValue
				($Charts/LineChart/Graph2D as Graph2D).y_max = MaxValue
				
				
				var BalancePlot = ($Charts/LineChart/Graph2D as Graph2D).add_plot_item("       Bilancio", Color(1, 1, 1, 1), 2.0)
				for x in range(0, 12):
					var y = BilancioAnnualePerMesi[x]
					BalancePlot.add_point(Vector2(x, y))
					
				
				var GainsPlot = ($Charts/LineChart/Graph2D as Graph2D).add_plot_item("       Entrata", Color(0, 1, 0.25, 1), 2)
				for x in range(0, 12):
					var y = EntrataAnnualePerMesi[x]
					GainsPlot.add_point(Vector2(x, y))
					
				
				var LossesPlot = ($Charts/LineChart/Graph2D as Graph2D).add_plot_item("       Uscita", Color(1, 0.22, 0, 1), 2.0)
				for x in range(0, 12):
					var y = UscitaAnnualePerMesi[x]
					LossesPlot.add_point(Vector2(x, y))
			
			1:
				$Charts/PieChart.reset_data()
				get_generi_annuali()
				var ArrayGeneri : Array[float] = [RetribuzioneAnnuale,LavoroAnnuale,AlimentariAnnuale,SvagoAnnuale,ImmobiliAnnuale,ArredamentoAnnuale,StudioAnnuale,TasseAnnuale,VeicoliAnnuale,AltreSpeseAnnuale]
				$Charts/PieChart.set_data(ArrayGeneri)
			
			2:
				$Charts/BarChart.reset_data()
				get_dati_annuali_per_mesi()
				var ArrayEntrataAnnuale = EntrataAnnualePerMesi.duplicate()
				var ArrayUscitaAnnuale = UscitaAnnualePerMesi.duplicate()
				$Charts/BarChart.set_data(ArrayEntrataAnnuale,ArrayUscitaAnnuale)
			
			3:
				pass

func update_history() -> void:
	$Cronologia/MarginContainer/RichTextLabel.text = ""
	var query : String = ""
	var crescenza : String = ""
	if OrdineDate == false:
		crescenza = "DESC"
	else:
		crescenza = "ASC"
	if $Cronologia/Ricerca/TestoRicerca.text == "" or $Cronologia/Ricerca/TestoRicerca.text == null:
		query = "SELECT * FROM spese ORDER BY Data " + crescenza
	else:
		query = "SELECT * FROM spese WHERE Nome LIKE '%"+$Cronologia/Ricerca/TestoRicerca.text+"%' ORDER BY Data " + crescenza
	database.query(query)
	for result in database.query_result:
		var NomeSpesa : String = result["Nome"]
		var TipoSpesa : float = 0
		match result["Entrata"]:
			0: TipoSpesa = -1
			1: TipoSpesa = 1
			false: TipoSpesa = -1
			true: TipoSpesa = 1
		var ImportoSpesa : String = ""
		if TipoSpesa == 1:
			ImportoSpesa = "[color=green]"+str(result["Importo"]*TipoSpesa)+"[/color]"
		elif TipoSpesa == -1:
			ImportoSpesa = "[color=red]"+str(result["Importo"]*TipoSpesa)+"[/color]"
		var GenereSpesa : String = ""
		match result["Tipologia"]:
			0: GenereSpesa = "[img=valign]res://Main/Assets/GREEN.png[/img] Retribuzione"
			1: GenereSpesa = "[img=valign]res://Main/Assets/RED.png[/img] Lavoro"
			2: GenereSpesa = "[img=valign]res://Main/Assets/ROSE.png[/img] Alimentari"
			3: GenereSpesa = "[img=valign]res://Main/Assets/CYAN.png[/img] Svago"
			4: GenereSpesa = "[img=valign]res://Main/Assets/YELLOW.png[/img] Immobili"
			5: GenereSpesa = "[img=valign]res://Main/Assets/PINK.png[/img] Arredamento"
			6: GenereSpesa = "[img=valign]res://Main/Assets/BLUE.png[/img] Studio"
			7: GenereSpesa = "[img=valign]res://Main/Assets/ORANGE.png[/img] Tasse"
			8: GenereSpesa = "[img=valign]res://Main/Assets/VIOLET.png[/img] Veicoli"
			9: GenereSpesa = "[img=valign]res://Main/Assets/BLACK.png[/img] Altre spese"
			-1: GenereSpesa = "GENERE NON SPECIFICATO (ERRORE)"
		var DataSpesa = result["Data"]
		$Cronologia/MarginContainer/RichTextLabel.text +=\
		"\n[b]Nome[/b]: "+NomeSpesa+\
		"\n[b]Importo[/b]: "+ImportoSpesa+\
		"\n[b]Genere[/b]: "+GenereSpesa+\
		"\n[b]Data[/b]: "+DataSpesa+\
		"\n\n[u]______________________________________________[/u]\n"

func _on_ordine_pressed() -> void:
	OrdineDate = !OrdineDate
	if OrdineDate == true:
		($Cronologia/Ricerca/Ordine as Button).text = "CRES."
	else:
		($Cronologia/Ricerca/Ordine as Button).text = "DECR."
	update_history()
func _on_testo_ricerca_text_changed(_new_text: String) -> void:
	update_history()
func _on_item_pressed(id):
	var item_name = ($Background/Dropdown as MenuButton).get_popup().get_item_text(id)
	if item_name == "Cambia sfondo":
	#questo fa comparire il file dialog
		($Background/FileDialog as FileDialog).popup()

func _on_file_dialog_file_selected(path: String) -> void:
	if FileAccess.file_exists(path):
		load_bg_from_path(path)

func save_image_path(path):
	var OldSettings = ResourceLoader.load(SETTINGS_PATH)
	if OldSettings != null:
		(OldSettings as Settings).BG_PATH = path
		ResourceSaver.save(OldSettings,SETTINGS_PATH)
	else:
		print("Impostazioni non trovate")

func load_bg_from_path(path):
	print("LOADING IMAGE FROM " + path)
	var image = Image.new()
	var err = image.load(path)
	if err != OK:
		var popup_tweener = create_tween()
		popup_tweener.tween_property($Background/Dropdown/ErrorBox,"modulate",Color(1,1,1,1),1.5)
		await get_tree().create_timer(3,true).timeout
		var popout_tweener = create_tween()
		popout_tweener.tween_property($Background/Dropdown/ErrorBox,"modulate",Color(1,1,1,0),1.5)
	else:
		save_image_path(path)
		var BackgroundImage = ImageTexture.create_from_image(image)
		($Background/TextureRect as TextureRect).texture = BackgroundImage

func _on_date_option_item_selected(index: int) -> void:
	AnnoSelezionato = int(($ChooseDate/DateOption as OptionButton).get_item_text(index))
	match $Charts/OptionButton.selected:
			0:
				get_dati_annuali_per_mesi()
			
			1:
				get_generi_annuali()
				
			
			2:
				get_dati_annuali_per_mesi()
			
			3:
				pass
	($ChooseDate/DateOption as OptionButton).focus_mode = Control.FOCUS_NONE
	update_charts()
