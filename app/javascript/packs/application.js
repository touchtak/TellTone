// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.

//= stub flash_window
//= require_tree .
//= require jquery
//= require jquery.jscroll.min.js
//= require rails-ujs
//= require audiojs

import Rails from "@rails/ujs"
import Turbolinks from "turbolinks"
import * as ActiveStorage from "@rails/activestorage"
import "channels"

import "jquery";
import "popper.js";
import "bootstrap";
import "../stylesheets/application";

Rails.start()
Turbolinks.start()
ActiveStorage.start()

// 無限スクロール用
/* global $ */
$(window).on('scroll', function() {
  var scrollHeight = $(document).height();
  var scrollPosition = $(window).height() + $(window).scrollTop();
  if ( (scrollHeight - scrollPosition) / scrollHeight <= 0.05) {
    $('.jscroll').jscroll({
      contentSelector: '.scroll-list',
      nextSelector: 'span.next:last a'
    });
  }
});

// ページ最上部移動ボタン用
$(function() {
  $('#back').on('click', function(event){
    $('body, html').animate({
      scrollTop:0
    }, 800);
    event.preventDefault();
  });
});

// ハンバーガーメニュー用
$(function() {
  $('#menu-trigger').on('click', function(event) {
    $(this).toggleClass('active');
    $('#sp-menu').fadeToggle();
    event.preventDefault();
  });
});

// 音声再生機能
$(document).ready(function () {
  var currentPage = 0; // 現在のページ番号
  var resultsPerPage = 5; // 1ページに表示する検索結果の数

  $("#search-button").click(function () {
    var keyword = $("#search-input").val();
    currentPage = 0; // 検索ボタンが押された時にページ番号をリセット

    // 検索結果を非同期で取得
    searchResults(keyword, currentPage);
  });

  // '次へ'ボタンがクリックされた時の処理
  $("#next-button").click(function () {
    var keyword = $("#search-input").val();
    currentPage++; // ページ番号をインクリメント

    // 検索結果を非同期で取得
    searchResults(keyword, currentPage);
  });

  function searchResults(keyword, page) {
    $.ajax({
      url: "/search",
      type: "GET",
      data: { keyword: keyword, page: page, per_page: resultsPerPage },
      success: function (response) {
        // ページネーションの制御
        if (response.length > 0) {
          $("#next-button").show(); // 次の結果がある場合、'次へ'ボタンを表示
        } else {
          $("#next-button").hide(); // 次の結果がない場合、'次へ'ボタンを非表示
        }

        // 検索結果を表示
        $("#search-results").html(response);
      },
    });
  }
});