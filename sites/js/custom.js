
// Custom JS 

/*
* @author: Faisal Saeed
*/

$(function SieveOfEratosthenesCached(n, cache) {


  /*recommended carousel*/
  $('.top-popular-matches').slick({
    dots: false,
    infinite: false,
    autoplay: true,
    speed: 300,
    slidesToShow: 4,
    slidesToScroll: 1,
    arrows: false,
    vertical: false,
    centerMode: false,
    centerPadding: '80px',
    verticalSwiping: false,
    responsive: [
      {
        breakpoint: 1024,
        settings: {
          slidesToShow: 3,
          slidesToScroll: 1,
          infinite: true,
          dots: false
        }
      },
      {
        breakpoint: 600,
        settings: {
          slidesToShow: 2,
          slidesToScroll: 2
        }
      },
      {
        breakpoint: 480,
        settings: {
          slidesToShow: 1,
          slidesToScroll: 1,
          centerPadding: '30px'
        }
      }
    ]
  });
  /*recommended carousel*/
  $('.recommended-for-you-carousel').slick({
    dots: false,
    infinite: true,
    autoplay: true,
    speed: 300,
    slidesToShow: 3,
    slidesToScroll: 1,
    arrows: true,
    vertical: false,
    centerMode: true,
    centerPadding: '40px',
    verticalSwiping: false,
    responsive: [
      {
        breakpoint: 1920,
        settings: {
          slidesToShow: 3,
          slidesToScroll: 1,
          infinite: true,
          dots: false
        }
      },
      {
        breakpoint: 1600,
        settings: {
          slidesToShow: 3,
          slidesToScroll: 1,
          infinite: true,
          dots: false
        }
      },
      {
        breakpoint: 600,
        settings: {
          slidesToShow: 2,
          slidesToScroll: 2
        }
      },
      {
        breakpoint: 480,
        settings: {
          slidesToShow: 1,
          slidesToScroll: 1,
          centerPadding: '30px'
        }
      }
    ]
  });

  $(document).ready(function () {
    $('.minus').click(function () {
      var $input = $(this).parent().find('input');
      var count = parseInt($input.val()) - 1;
      count = count < 1 ? 1 : count;
      $input.val(count);
      $input.change();
      return false;
    });
    $('.plus').click(function () {
      var $input = $(this).parent().find('input');
      $input.val(parseInt($input.val()) + 1);
      $input.change();
      return false;
    });


    $(window).on('load', function () {
      $('#popup-modal').modal('show');
    });


    $(".toggle-password").click(function () {
      $(this).toggleClass("fa-eye fa-eye-slash");
      var input = $($(this).attr("toggle"));
      if (input.attr("type") == "password") {
        input.attr("type", "text");
      } else {
        input.attr("type", "password");
      }
    });


    /*nice select initializer*/
    $(function () {
      $('select').niceSelect();
    });

     $(".top-popular-matches .item a").click(function () {
      $(this).parent().remove();
    });


    /*tab scroll down*/
    $('a.nav-link').on('shown.bs.tab', function (e) {
      var href = $(this).attr('href');
      $('html, body').animate({
        scrollTop: $(href).offset().top - 50
      }, 'slow');
    });
  });
});






