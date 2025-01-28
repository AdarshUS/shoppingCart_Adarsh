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
      <a class="cartContainer" href="cart.cfm"><i data-count="4" class="fa-solid fa-cart-shopping"><div class="itemcount">4</div></i></a>
      <div class="logoutContainer">
         <cfif structKeyExists(session,"loginuserId")>
            <button onclick="logoutUser()">
               <i class="fa-solid fa-right-from-bracket"></i>
               <div class="header_menutext">LogOut</div>
            </button>
         <cfelse>
            <a href="userLogin.cfm">
               <i class="fa-solid fa-arrow-right-to-bracket"></i>
               <div class="header_menutext">Login</div>
            </a>
         </cfif>
      </div>
   </div>
</header>