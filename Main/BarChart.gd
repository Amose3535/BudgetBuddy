extends Panel

func set_data(Entrate : Array[float] = [0,0,0,0,0,0,0,0,0,0,0,0], Uscite : Array[float] = [0,0,0,0,0,0,0,0,0,0,0,0]):
	var MaxArray : Array[float] = [Entrate.max(),Uscite.max()]
	var MaxValue : float = MaxArray.max()
	var MaxLabel : Label = $Container/AsseY/VSeparator/Max
	var HalfLabel : Label = $Container/AsseY/VSeparator/MaxHalf
	MaxLabel.text = str(MaxValue)
	HalfLabel.text = str(MaxValue/2)
	
	
	($Container/Gennaio/Entrate as ProgressBar).max_value = MaxValue
	($Container/Febbraio/Entrate as ProgressBar).max_value = MaxValue
	($Container/Marzo/Entrate as ProgressBar).max_value = MaxValue
	($Container/Aprile/Entrate as ProgressBar).max_value = MaxValue
	($Container/Maggio/Entrate as ProgressBar).max_value = MaxValue
	($Container/Giugno/Entrate as ProgressBar).max_value = MaxValue
	($Container/Luglio/Entrate as ProgressBar).max_value = MaxValue
	($Container/Agosto/Entrate as ProgressBar).max_value = MaxValue
	($Container/Settembre/Entrate as ProgressBar).max_value = MaxValue
	($Container/Ottobre/Entrate as ProgressBar).max_value = MaxValue
	($Container/Novembre/Entrate as ProgressBar).max_value = MaxValue
	($Container/Dicembre/Entrate as ProgressBar).max_value = MaxValue
	
	($Container/Gennaio/Entrate as ProgressBar).value = Entrate[0]
	($Container/Febbraio/Entrate as ProgressBar).value = Entrate[1]
	($Container/Marzo/Entrate as ProgressBar).value = Entrate[2]
	($Container/Aprile/Entrate as ProgressBar).value = Entrate[3]
	($Container/Maggio/Entrate as ProgressBar).value = Entrate[4]
	($Container/Giugno/Entrate as ProgressBar).value = Entrate[5]
	($Container/Luglio/Entrate as ProgressBar).value = Entrate[6]
	($Container/Agosto/Entrate as ProgressBar).value = Entrate[7]
	($Container/Settembre/Entrate as ProgressBar).value = Entrate[8]
	($Container/Ottobre/Entrate as ProgressBar).value = Entrate[9]
	($Container/Novembre/Entrate as ProgressBar).value = Entrate[10]
	($Container/Dicembre/Entrate as ProgressBar).value = Entrate[11]
	
	
	
	
	($Container/Gennaio/Uscite as ProgressBar).max_value = MaxValue
	($Container/Febbraio/Uscite as ProgressBar).max_value = MaxValue
	($Container/Marzo/Uscite as ProgressBar).max_value = MaxValue
	($Container/Aprile/Uscite as ProgressBar).max_value = MaxValue
	($Container/Maggio/Uscite as ProgressBar).max_value = MaxValue
	($Container/Giugno/Uscite as ProgressBar).max_value = MaxValue
	($Container/Luglio/Uscite as ProgressBar).max_value = MaxValue
	($Container/Agosto/Uscite as ProgressBar).max_value = MaxValue
	($Container/Settembre/Uscite as ProgressBar).max_value = MaxValue
	($Container/Ottobre/Uscite as ProgressBar).max_value = MaxValue
	($Container/Novembre/Uscite as ProgressBar).max_value = MaxValue
	($Container/Dicembre/Uscite as ProgressBar).max_value = MaxValue
	
	($Container/Gennaio/Uscite as ProgressBar).value = Uscite[0]
	($Container/Febbraio/Uscite as ProgressBar).value = Uscite[1]
	($Container/Marzo/Uscite as ProgressBar).value = Uscite[2]
	($Container/Aprile/Uscite as ProgressBar).value = Uscite[3]
	($Container/Maggio/Uscite as ProgressBar).value = Uscite[4]
	($Container/Giugno/Uscite as ProgressBar).value = Uscite[5]
	($Container/Luglio/Uscite as ProgressBar).value = Uscite[6]
	($Container/Agosto/Uscite as ProgressBar).value = Uscite[7]
	($Container/Settembre/Uscite as ProgressBar).value = Uscite[8]
	($Container/Ottobre/Uscite as ProgressBar).value = Uscite[9]
	($Container/Novembre/Uscite as ProgressBar).value = Uscite[10]
	($Container/Dicembre/Uscite as ProgressBar).value = Uscite[11]

func reset_data():
	$Container/Aprile/Entrate.value = 0
	$Container/Maggio/Entrate.value = 0
	$Container/Giugno/Entrate.value = 0
	$Container/Luglio/Entrate.value = 0
	$Container/Agosto/Entrate.value = 0
	$Container/Settembre/Entrate.value = 0
	$Container/Ottobre/Entrate.value = 0
	$Container/Novembre/Entrate.value = 0
	$Container/Dicembre/Entrate.value = 0
	$Container/Gennaio/Uscite.value = 0
	$Container/Febbraio/Uscite.value = 0
	$Container/Marzo/Uscite.value = 0
	$Container/Aprile/Uscite.value = 0
	$Container/Maggio/Uscite.value = 0
	$Container/Giugno/Uscite.value = 0
	$Container/Luglio/Uscite.value = 0
	$Container/Agosto/Uscite.value = 0
	$Container/Settembre/Uscite.value = 0
	$Container/Ottobre/Uscite.value = 0
	$Container/Novembre/Uscite.value = 0
	$Container/Dicembre/Uscite.value = 0
	
