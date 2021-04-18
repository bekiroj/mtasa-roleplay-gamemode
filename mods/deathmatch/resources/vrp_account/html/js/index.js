var un = "";
var pw = "";
var page = "";

$('.to').on('click', function() {
    show($(this).attr("data-to"));
    return false;
});

$('.recovery').on('click', function() {
	show("recovery");
    return false;
});

$('#trpRedirect').on('click', function() {
	mta.triggerEvent("redirectTRP");
    return false;
});

$('#crpRedirect').on('click', function() {
	mta.triggerEvent("redirectCRP");
    return false;
});

$('.rememberText').on('click', function() {
	if ($('#rememberMe').is(":checked")) {
		$('#rememberMe').prop('checked', false);
		mta.triggerEvent("rememberMe", 0);
	} else {
		$('#rememberMe').prop('checked', true);
		mta.triggerEvent("rememberMe", 1);
	}
    return false;
});

$('.rememberMe').on('click', function() {
	if ($('#rememberMe').is(":checked")) {
		$('#rememberMe').prop('checked', false);
		mta.triggerEvent("rememberMe", 0);
	} else {
		$('#rememberMe').prop('checked', true);
		mta.triggerEvent("rememberMe", 1);
	}
    return false;
});

function setChecked(){
	$('#rememberMe').prop('checked', true);
}

function error(message) {
	toastr.error(message);
}

function info(message) {
	toastr.success(message);
}

function logIn(){
	if (page == 'login') {
		mta.triggerEvent("sign-in", $('#Lusername').val(), $('#Lpassword').val());
	}
}

function startRegister(){
	mta.triggerEvent("register", $('#Rusername').val(), $('#Rpassword').val(), $('#Remail').val());
}

function startRecover(){
	mta.triggerEvent("recover", $('#Rrnumber').val(), $('#Rrusername').val());
}

function checkRecoveryCode(){
	mta.triggerEvent("recovery-check", $('#Rrusername2').val());
}

function changeAccountRecoveryPassword(){
	mta.triggerEvent("recovery-submit", $('#Lpassword2').val());
}

function changeQuestionButtonText(txt){
	$('#questSend').html(txt);
}

function changeBanDetailsText(txt){
	$('#banDetails').html(txt);
}

var questAnswers = [];
function push_question(quest,a,b,c,key,IDkey) {
	questID = IDkey;
	$(".question").append(`<div class="accountBox" required><span>`+quest+`</span><br><br><div style="margin-top: -10px;"><div class="answer" id="`+questID+`1"><input style="margin-left: -45px;" type="radio" name="x`+questID+`" id="answer`+questID+`1" value="` + a + `"><div class="answer label" id="`+questID+`1" onclick="toggleRadio(`+questID+`, 1);">` + a + `</div></div><div class="answer" id="`+questID+`2"><input style="margin-left: -45px;" type="radio" name="x`+questID+`" id="answer`+questID+`2" value="` + b + `"><div class="answer label" id="`+questID+`2" onclick="toggleRadio(`+questID+`, 2);">` + b + `</div></div><div class="answer" id="`+questID+`3"><input style="margin-left: -45px;" type="radio" name="x`+questID+`" id="answer`+questID+`3" value="` + c + `"><div class="answer label" id="`+questID+`3" onclick="toggleRadio(`+questID+`, 3);">` + c + `</div></div><div><div>`);
	questAnswers[IDkey] = key;
}

function toggleRadio(questID, radioID) {
	$(`#answer` + questID + radioID).prop('checked', true);
}

$(document).ready(function() {
	mta.triggerEvent("ready-account");
});


function checkQuestions() {
	var right = 0;
	var wrong = 0;
	$.each([ 1, 2, 3, 4, 5, 6, 7, 8 ], function( index, value ) {
		if($('#answer' + value + questAnswers[value]).is(":checked")) {
			right++;
		} else {
			wrong++;
		}
	});
	mta.triggerEvent("check-quest", right, wrong);
}

function setChecked(){
	$('#rememberMe').prop('checked', true);
}

function setUsername(txt){
	$('#Lusername').val(txt);
}

function setPassword(txt){
	$('#Lpassword').val(txt);
}

function show(to){
	page = to;
	$(".box").hide();
	$("#" + to).show();
	if(to == "login"){
		$("#Lusername").removeAttr("readonly");
	}
}

show("login");
$(".box").css("z-index", "1");