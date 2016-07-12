if (!window.dotjsLoaded) {
  window.dotjsLoaded = true;

  const inboxWhitelist = ['aleks@stripe.com'];

  function embedCustomCSS() {
    const link = document.createElement('style');
    link.type = 'text/css'
    link.innerHTML = `
    .yi { /* 'Inbox' label */
      display: none !important;
    }

    .yf.xY { /* attachment/calendar icon */
      width: 0px !important;
    }

    .spacer {
      float: left;
      min-height: 1px;
      width: 10px !important;
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

    $inboxContainer.insertBefore($middleNode, $inboxNode);
    $inboxContainer.insertBefore($filteredNode, $middleNode);

    const $spacer = document.createElement('div');
    $spacer.classList.add('spacer');
    $inboxContainer.insertBefore($spacer, $filteredNode);

    $filteredNode.classList.add('left-inbox');
    $middleNode.classList.add('spacer');
    $inboxNode.classList.add('right-inbox');
  }

  window.setTimeout(querySidebar, 100);
  function querySidebar() {
    if (document.title.startsWith('Inbox')) {
      if (!inboxWhitelist.some(e => document.title.includes(e))) return;

      $sidebar = document.querySelector('div.nH.oy8Mbf.nn.aeN');
      $viewContainer = document.querySelector('div.nH > div > div:nth-child(2) > div.no > div:nth-child(2)');
      sidebarWidth = $sidebar.style.width.slice(0, -2);

      embedCustomCSS();
      toggleSidebar();
      fillWidthAndSwap();

      const $navbar = document.querySelector('div.gb_ue.gb_tf');
      const toggleButton = document.createElement('button');
      toggleButton.appendChild(document.createTextNode('Toggle Sidebar'));
      for (let cls of ['T-I', 'J-J5-Ji', 'ash', 'T-I-ax7', 'L3']) {
        toggleButton.classList.add(cls);
      }
      toggleButton.onclick = toggleSidebar;
      const toggleButtonContainer = document.createElement('div');
      toggleButtonContainer.classList.add('toggle-sidebar-button-container');
      toggleButtonContainer.appendChild(toggleButton);

      $navbar.insertBefore(toggleButtonContainer, $navbar.firstChild);
    } else {
      window.setTimeout(querySidebar, 100);
    }
  }
}
