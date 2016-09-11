if (window.location.href.match(/https:\/\/mail.google.com\/mail\/u\/\d\//) && !window.dotjsLoaded) {

  window.dotjsLoaded = true;

  // Modified from: https://codepen.io/pprice/pen/splkc/
  (function($) {
    $.fn.drags = function(opt) {

      opt = $.extend({handle: "",cursor: "ew-resize", min: 10}, opt);

      if (opt.handle === "") {
        var $el = this;
      } else {
        var $el = this.find(opt.handle);
      }

      var priorCursor = $('body').css('cursor');

      $(document).on("mouseup", function() {
        $('body').css('cursor', priorCursor);
        $('.draggable').removeClass('draggable').parents().off('mousemove');
      });

      return $el.css('cursor', opt.cursor).on("mousedown", function(e) {

        priorCursor = $('body').css('cursor');
        $('body').css('cursor', opt.cursor);

        if (opt.handle === "") {
          var $drag = $(this).addClass('draggable');
        } else {
          var $drag = $(this).addClass('active-handle').parent().addClass('draggable');
        }

        var z_idx = $drag.css('z-index');
        var drg_h = $drag.outerHeight();
        var drg_w = $drag.outerWidth();
        var pos_y = $drag.offset().top + drg_h - e.pageY;
        var pos_x = $drag.offset().left + drg_w - e.pageX;

        $drag.css('z-index', 1000).parents().on("mousemove", function(e) {

          var prev = $('.draggable').prev();
          var next = $('.draggable').next();

          // Assume 50/50 split between prev and next then adjust to
          // the next X for prev

          var total = prev.outerWidth() + next.outerWidth();

          var leftPercentage = (((e.pageX - prev.offset().left) + (pos_x - drg_w / 2)) / total);
          var rightPercentage = 1 - leftPercentage;

          if (leftPercentage * 100 < opt.min || rightPercentage * 100 < opt.min) {
            return;
          }

          prev.css('flex', leftPercentage.toString());
          next.css('flex', rightPercentage.toString());
        });

        e.preventDefault(); // disable selection
      });
    }
  })(jQuery);

  const inboxWhitelist = ['aykamko@gmail.com'];

  function nthParent(node, n) {
    let parent = node;
    while (n-- > 0) parent = parent.parentNode;
    return parent;
  }

  function nthFirstChild(node, n) {
    let child = node;
    while (n-- > 0) child = child.firstChild;
    return child;
  }

  const sidebarQuery = () => nthParent(document.querySelector('[aria-label="Navigate to"]'), 3);
  const navbarQuery = () => nthFirstChild(document.querySelector('[role="banner"]'), 2);
  const viewContainerQuery = () => nthParent(document.querySelector('[role="main"]'), 8);

  function embedCustomCSS() {
    const link = document.createElement('style');
    link.type = 'text/css'
    link.innerHTML = `
    .yi { /* 'Inbox' label */
      display: none !important;
    }

    .yg { /* Attachments icon */
      width: 0px !important;
    }

    .yf.xY { /* attachment/calendar icon */
      width: 0px !important;
    }

    .flex-box {
      display: flex;
      margin: 0;
    }

    .flex-box .flex-col {
      flex: 0.5;
    }

    .spacer {
      float: left;
      min-height: 1px;
      width: 15px !important;
    }

    .handle {
      display: flex;
      align-items: center;
      justify-content: center;
    }

    .handle:hover::after {
      color: #333;
      content: "• • • • •";
      display: block;
      text-align: center;
    }

    .left-inbox {
      width: calc(55% - 10px) !important;
    }

    .right-inbox {
      width: calc(45% - 10px) !important;
    }

    .toggle-sidebar-button-container {
      display: flex;
      align-items: center;
      justify-content: center;
    }
    `;
    const s = document.getElementsByTagName('style')[0];
    s.parentNode.insertBefore(link, s);
  }

  let $viewContainer;
  let $sidebar;
  let sidebarWidth;

  function toggleSidebar() {
    if ($sidebar.style.display === 'block' || !$sidebar.style.display) {
      $viewContainer.style.width = `${screen.width - 135}px`;
      $sidebar.style.display = 'none';
    } else {
      $viewContainer.style.width = `${screen.width - 165 - sidebarWidth}px`;
      $sidebar.style.display = 'block';
    }
  }

  function fillWidthAndSwap() {
    const $inboxContainer = document.querySelector('div.aia > div > div.nH > div.no');
    const $inboxNode = $inboxContainer.childNodes[0];
    const $middleNode = $inboxContainer.childNodes[1];
    const $filteredNode = $inboxContainer.childNodes[2];

    // $inboxContainer.insertBefore($middleNode, $inboxNode);
    // $inboxContainer.insertBefore($filteredNode, $middleNode);
    //
    // const $spacer = document.createElement('div');
    // $spacer.classList.add('spacer');
    // $inboxContainer.insertBefore($spacer, $filteredNode);

    $inboxContainer.classList.add('flex-box');
    $inboxContainer.classList.add('inbox-container');
    $inboxNode.classList.add('flex-col');
    $middleNode.classList.add('spacer');
    $middleNode.classList.add('handle');
    $filteredNode.classList.add('flex-col');

    $middleNode.style.height = `${$inboxContainer.clientHeight}px`
    const observer = new MutationObserver(mutations => {
      $middleNode.style.height = `${$inboxContainer.clientHeight}px`
    });
    observer.observe($inboxContainer, {
      attributes: true,
    });
  }

  function createToggleButton() {
    const toggleButton = document.createElement('button');
    toggleButton.appendChild(document.createTextNode('Toggle Sidebar'));
    for (let cls of ['T-I', 'J-J5-Ji', 'ash', 'T-I-ax7', 'L3']) {
      toggleButton.classList.add(cls);
    }
    toggleButton.onclick = toggleSidebar;
    const toggleButtonContainer = document.createElement('div');
    toggleButtonContainer.classList.add('toggle-sidebar-button-container');
    toggleButtonContainer.appendChild(toggleButton);

    return toggleButtonContainer;
  }

  function applyDotjs() {
    $sidebar = sidebarQuery();
    $viewContainer = viewContainerQuery();
    sidebarWidth = $sidebar.style.width.slice(0, -2);

    embedCustomCSS();
    toggleSidebar();
    fillWidthAndSwap();

    const $navbar = navbarQuery();
    $navbar.insertBefore(createToggleButton(), $navbar.firstChild);

    $('.handle').drags();
  }

  let observer;
  observer = new MutationObserver(mutations => {
    applyDotjs();
    observer.disconnect();
  });

  const $loading = document.getElementById('loading');

  if ($loading) {
    const loadingText = $loading.getElementsByClassName('msg')[0].innerText;

    if (inboxWhitelist.some(e => loadingText.includes(e))) {
      observer.observe($loading, {
        attributes: true,
      });
    }
  }
}
