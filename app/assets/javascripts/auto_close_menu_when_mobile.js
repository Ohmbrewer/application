$(window).bind('resize load',function(){
    if( $(this).width() < 1024 )
    {
        $('.collapse').removeClass('in');
        $('.collapse').addClass('out');
    }
    else
    {
        $('.collapse').removeClass('out');
        $('.collapse').addClass('in');
    }
});