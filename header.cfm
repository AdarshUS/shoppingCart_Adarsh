<header>
   <a class="header_logo" href="homePage.cfm">
      <img src="./Assets/Images/cart1.jpeg" alt="logo" width="60">
      <span class="header_logoText">My Cart</span>
   </a>
   <div class="header_searchBar">
      <i class="fa-solid fa-magnifying-glass"></i>
      <form method="post" action="searchResult.cfm">
         <input type="text" name = "searchInput" placeholder="Search for Products, Brands and More">
         <button class="searchBtn" name="searchBtn" type="submit">Search</button>
      </form>
   </div>
   <div class="header_menu">
      <div class="profileContainer">
         <i class="fa-solid fa-user"></i>
         <span></span>
      </div>
      <div class="cartContainer"><i class="fa-solid fa-cart-shopping"></i>cart</div>
      <div class="logoutContainer">
         <i class="fa-solid fa-right-from-bracket"></i>
         <div class="header_menutext">LogOut</div>
      </div>
   </div>
</header>