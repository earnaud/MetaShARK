# about.R

### UI ###
aboutUI <- function(id, IM){
  ns <- NS(id)
  
  fluidPage(
    HTML(
      "<div>
        <h1>About MetaShARK dev team</h1>
        <p>MetaShARK is developped within the french Museum National d'Histoire Naturelle / UMS Patrimoine Naturel / Pole National de Biodiversité.
        Its development team is currently composed of <a href='https://fr.linkedin.com/in/elie-arnaud-440132151?trk=people-guest_profile-result-card_result-card_full-click'>Elie Arnaud</a>
        (lead developer) and <a href ='https://fr.linkedin.com/in/yvan-le-bras-aa2b3738?trk=people-guest_profile-result-card_result-card_full-click'>Yvan Le Bras</a> (team director).</p>
      </div>
      
      <div>
        <h1>Thanks</h1>
        MetaShARK could not be built without the help of those people: </br>
        <ul>
          <li>Colin Smith (EDI, US)</li> who collaborates with us since March 2019, and currently provides us the <a href='https://github.com/EDIorg/EMLassemblyline'>EML Assembly Line</a> tool.
        </ul>
      </div>
      
      <div>
        <h1>Sources</h1>
        <h2>Computer material</h2>
        <h2>Literature</h2>
        <ul>
          <li>Michener, William & Brunt, James & J. Helly, John & B. Kirchner, Thomas & G. Stafford, Susan. (1997). Non-geospatial metadata for the ecological sciences. Ecological Applications. 7. 330-342.</li>
          
        </ul>
      </div>
      "
    )
  )
}



### SERVER ###
about <- function(input, output, session, IM){
  
}