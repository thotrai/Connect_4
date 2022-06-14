var me={token:null,piece_color:null};
var game_status={};
var board={};
var last_update=new Date().getTime();
var timer=null;

//arxikopoihsh selidas
$(function () {
    draw_empty_board();
	fill_board();
	
	$('#connect_four_login').click( login_to_game);
	$('#connect_four_reset').click( reset_board);
	$('#do_move').click( do_move);
	$('#move_div').hide();
	$('#victory').hide();
	$('#draw').hide();
	game_status_update();
});

//dhmiourgia pinaka
function draw_empty_board() {
	var t='<table id="connect_four_table">';
	for(var i=6;i>0;i--) {
		t += '<tr>';
		for(var j=1;j<8;j++) {
			t += '<td class="slot" id="square_'+j+'_'+i+'">' + j +','+i+'</td>';
		}
		t+='</tr>';
	}
	t+='</table>';
	
	$('#connect_four_board').html(t);
}

//ajax request gia epistrofi tou pinaka board
function fill_board() {
	$.ajax({url: "connect_four.php/board/", 
		headers: {"X-Token": me.token},
			//dataType: "json",
			//contentType: 'application/json',
			//data: JSON.stringify( {token: me.token}),
			success: fill_board_by_data });
}

//ajax request gia arxikopoihsh tou pinaka
function reset_board() {
	
	$('#victory').hide();
	$('#draw').hide();

	$.ajax({url: "connect_four.php/board/", 
	headers: {"X-Token": me.token}, 
	method: 'POST',  
	success: fill_board_by_data });
	$('#move_div').hide();
	$('#game_initializer').show(2000);
}

//gemisma tou pinaka me ta pionia kathe fora meta apo th kinhsh kai elegxos nikhth
function fill_board_by_data(data) {
	var win=0;
	var counter=0;
	board=data;
	for(var i=0;i<data.length;i++) {
		var o = data[i];
		var id = '#square_'+ o.x +'_' + o.y;
		var c = (o.piece!=null)?o.piece_color + o.piece:'';
		var im = (o.piece!=null)?'<img class="piece" src="img/'+c+'.png">':'';
		$(id).addClass(o.b_color+'_square').html(im);
	
		//katheta
		//elegxos kathe sthlhs
		if(i>2 && i<6 || i>8 && i<12 || i>14 && i<18 || i>20 && i<24 || i>26 && i<30 || i>32 && i<36 || i>38 && i<42){
		if(o.piece_color=='R'){
			var o1 = data[i-1];
			if(o1.piece_color=='R'){
				var o2 = data[i-2];
				if(o2.piece_color=='R'){
					var o3 = data[i-3];
					if(o3.piece_color=='R'){
						win = 1;
					}
				}
			}
		}
		if(o.piece_color=='Y'){
			var o1 = data[i-1];
			if(o1.piece_color=='Y'){
				var o2 = data[i-2];
				if(o2.piece_color=='Y'){
					var o3 = data[i-3];
					if(o3.piece_color=='Y'){
						$('#victory').show(1000);
						win = 1;
					}
				}
			}
		}
		}
		//orizontia
		if(i>17){
			if(o.piece_color=='R'){
				var o1 = data[i-6];
				if(o1.piece_color=='R'){
					var o2 = data[i-12];
					if(o2.piece_color=='R'){
						var o3 = data[i-18];
						if(o3.piece_color=='R'){
							win = 1;
						}
					}
				}
			}
			if(o.piece_color=='Y'){
				var o1 = data[i-6];
				if(o1.piece_color=='Y'){
					var o2 = data[i-12];
					if(o2.piece_color=='Y'){
						var o3 = data[i-18];
						if(o3.piece_color=='Y'){
							win = 1;
						}
					}
				}
			}
		}
		//diagwnia aristera panw pros deksia katw
		if(i>17){
			if(o.piece_color=='R'){
				var o1 = data[i-5];
				if(o1.piece_color=='R'){
					var o2 = data[i-10];
					if(o2.piece_color=='R'){
						var o3 = data[i-15];
						if(o3.piece_color=='R'){
							win = 1;
						}
					}
				}
			}
			if(o.piece_color=='Y'){
				var o1 = data[i-5];
				if(o1.piece_color=='Y'){
					var o2 = data[i-10];
					if(o2.piece_color=='Y'){
						var o3 = data[i-15];
						if(o3.piece_color=='Y'){
							win = 1;
						}
					}
				}
			}
		}
		//diagwnia aristera katw pros deksia panw
		if(i>20){
			if(o.piece_color=='R'){
				var o1 = data[i-7];
				if(o1.piece_color=='R'){
					var o2 = data[i-14];
					if(o2.piece_color=='R'){
						var o3 = data[i-21];
						if(o3.piece_color=='R'){
							win = 1;
						}
					}
				}
			}
			if(o.piece_color=='Y'){
				var o1 = data[i-7];
				if(o1.piece_color=='Y'){
					var o2 = data[i-14];
					if(o2.piece_color=='Y'){
						var o3 = data[i-21];
						if(o3.piece_color=='Y'){
							win = 1;
						}
					}
				}
			}
		}	

		//metraei ta poulia
		if(c!=''){
			counter += 1;
		}

		//ajax request gia isopalia
		if(counter==42){
			$.ajax({url: "connect_four.php/board/draw/", 
			headers: {"X-Token": me.token},
			//dataType: "json",
			//contentType: 'application/json',
			//data: JSON.stringify( {token: me.token}),
			success: draw() });
		}
	}
	//ajax request gia emfanisi nikhth
	if(win==1){

		$.ajax({url: "connect_four.php/board/win/", 
		headers: {"X-Token": me.token},
		//dataType: "json",
		//contentType: 'application/json',
		//data: JSON.stringify( {token: me.token}),
		success: game_result() });

	}
	
}
//emfanisi minima nikhth
function game_result(){
	$('#victory').show(1000);
}

//emfanisi minima isopalias
function draw(){
	$('#draw').show(1000);
}

//username & color
function login_to_game() {
	if($('#username').val()=='') {
		alert('You have to set a username');
		return;
	}
	var p_color = $('#pcolor').val();
	draw_empty_board();
	fill_board();
	
	$.ajax({url: "connect_four.php/players/"+p_color, 
			method: 'PUT',
			dataType: "json",
			headers: {"X-Token": me.token},
			contentType: 'application/json',
			data: JSON.stringify( {username: $('#username').val(), piece_color: p_color}),
			success: login_result,
			error: login_error});
}

//eisagwgh stoixeiwn paikti kai enhmerwsi tou game status
function login_result(data) {
	me = data[0];
	$('#game_initializer').hide();
	update_info();
	game_status_update();
}

//error msg
function login_error(data) {
	var x = data.responseJSON;
	alert(x.errormesg);
}

//ajax request gia epistrofi tou game status
function game_status_update() {
	clearTimeout(timer);
	$.ajax({url: "connect_four.php/status/", 
	success: update_status,
	headers: {"X-Token": me.token} });
}
//kathe 5s tsekarei to game_status
function update_status(data) {
	last_update=new Date().getTime();
	var game_stat_old = game_status;
	game_status=data[0];
	update_info();
	clearTimeout(timer);
	if(game_status.p_turn==me.piece_color &&  me.piece_color!=null) {
		x=0;
		// do play
		if(game_stat_old.p_turn!=me.piece_color) {
			fill_board();
		}
		$('#move_div').show(1000);
		timer = setTimeout(function() { game_status_update();}, 15000);
	} else {
		// must wait for something
		$('#move_div').hide(1000);
		timer = setTimeout(function() { game_status_update();}, 4000);
	}
 	
}
//enimerosi katastasis paikti kai partidas
function update_info(){
	$('#game_info').html("I am Player: "+me.piece_color+", my name is "+me.username +'<br>Token='+me.token+'<br>Game state: '+game_status.status+', '+ game_status.p_turn+' must play now.<br>The winner is: '+ game_status.result);	
}

//kinhsh paikti
function do_move() {
	var s = $('#the_move').val(); 

	var i=1; //gia thn sthlh y

	var a = s.trim().split(/[ ]+/); //a=[]
	if(a.length!=1) {
		alert('Must give 1 number!');
		return;
	}
	else if(a[0] <= 0 || a[0] > 7){
		alert('Must give a number between 1 and 7!');
		return;
	}
	$.ajax({url: "connect_four.php/board/piece/"+a[0]+'/'+i, 
			method: 'PUT',
			dataType: "json",
			contentType: 'application/json',
			data: JSON.stringify( {x: a[0], y: i}),
			headers: {"X-Token": me.token},
			success: move_result,
			error: login_error});
		
}

//enhmerwsh tou pinaka paixnidiou gia thn kainourgia kinhsh
function move_result(data){
	game_status_update();
	fill_board_by_data(data);
}