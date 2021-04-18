$(document).ready(function() {
   mta.triggerEvent('BankBrowser-ReadyBrowser');
});

$('.btn-sign-out').click(function(){
    $('#general, #waiting, #transferUI, #withdrawUI, #depositUI, #topbar').hide();
    $('body').removeClass("active");
    mta.triggerEvent('BankBrowser-CloseBrowser');
})
$('.back').click(function(){
    $('#depositUI, #withdrawUI, #transferUI').hide();
    $('#general').show();
})
$('#deposit').click(function(){
    $('#general').hide();
    $('#depositUI').show();
})
$('#withdraw').click(function(){
    $('#general').hide();
    $('#withdrawUI').show();
})
$('#transfer').click(function(){
    $('#general').hide();
    $('#transferUI').show();
})
$('#fingerprint-content').click(function(){
    $('.fingerprint-active, .fingerprint-bar').addClass("active")
    setTimeout(function(){
      $('#general').css('display', 'block')
        $('#topbar').css('display', 'flex')
        $('#waiting').css('display', 'none')
        $('.fingerprint-active, .fingerprint-bar').removeClass("active")
    }, 1400);
})
$("#deposit1").submit(function(e) {
    var amount = $("#amount").val();
    $("#amount").val('');
    mta.triggerEvent('BankBrowser-DepositMoney', amount);
});
$("#transfer1").submit(function(e) {
    e.preventDefault(); // Prevent form from submitting
    $.post('http://new_banking/transfer', JSON.stringify({
        to: $("#to").val(),
        amountt: $("#amountt").val()
    }));
    $('#transferUI').hide();
    $('#general').show();
    $("#amountt").val('');
});
$("#withdraw1").submit(function(e) {
    var amount = $("#amountw").val();
    $("#amountw").val('');
    mta.triggerEvent('BankBrowser-WidthrawMoney', amount);
});
document.onkeyup = function(data){
    if (data.which == 27){
        $('#general, #waiting, #transferUI, #withdrawUI, #depositUI, #topbar').hide();
        $('body').removeClass("active");
        $.post('http://new_banking/NUIFocusOff', JSON.stringify({}));
    }
}

function show(name) {
    $('#' + name).css('display', 'block');
}

function hide(name) {
    $('#general, #waiting, #transferUI, #withdrawUI, #depositUI, #topbar').hide();
}

function alert(message) {
    if (event.data.t == "success")
        $("#result").attr('class', 'alert-green');
    else
     $("#result").attr('class', 'alert-orange');
    $("#result").html(message).show().delay(5000).fadeOut();
}

function change(el, dat) {
    $('.' + el).text(dat);
}