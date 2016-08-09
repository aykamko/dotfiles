if (window.location.href.match(/https:\/\/mail.google.com\/mail\/u\/\d\/#inbox/) && !window.dotjsLoaded) {
  window.dotjsLoaded = true;

  const inboxWhitelist = ['aleks@stripe.com'];

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
  }

  let observer;
  observer = new MutationObserver(mutations => {
    applyDotjs();
    observer.disconnect();
  });

  const $loading = document.getElementById('loading');
  const loadingText = $loading.getElementsByClassName('msg')[0].innerText;

  if (inboxWhitelist.some(e => loadingText.includes(e))) {
    observer.observe($loading, {
      attributes: true,
    });
  }
}
