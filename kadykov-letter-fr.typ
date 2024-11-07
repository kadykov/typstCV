#import "style.typ": *

#let today = datetime.today()
#let suffix = {
  let day = today.day()
  if day == 1 or day == 21 or day == 31 {
    "st"
  } else if day == 2 or day == 22 {
    "nd"
  } else if day == 3 or day == 23 {
    "rd"
  } else {
    "th"
  }
}

// Call the function from `style.typ` and pass variables to set up the document style
#show: setup-style.with(
  language: "fr",
  hyphenate: true,
)

#let from-content = [
  Mons,
  Belgique

  #today.display(
    "[month repr:long] [day padding:none]"
  )#super(suffix),
  #today.year()
]

#let to-content = [
  // Future Employer

  // Company

  // Street 123\
  // City\
  // 00000 \
  // Country
]

#context {
  let intro-height = calc.max(
    measure(from-content).height,
    measure(to-content).height,
  )

  box(height: intro-height)[#from-content]
  h(1fr)
  box(height: intro-height, width: bodywidth)[#to-content]
}

#v(1em)

#align(right)[
  #block(width: bodywidth)[
    #set align(left)

    = Lettre au Futur Employeur

    Cher Futur Employeur,

    Je vous écris
    pour vous offrir une vue d'ensemble
    de mon parcours professionnel,
    en mettant en lumière mon expertise
    en photonique,
    magnetotransport,
    mesures de haute précision,
    et technologie THz.

    == Photonique et Magnetotransport \ au L2C et IPM RAS

    J'ai commencé ma carrière dans la recherche fondamentale
    en tant qu'Ingénieur de Recherche.
    //
    Mon travail de thèse,
    une collaboration entre
    le Laboratoire Charles Coulomb (L2C)
    et l'Institut de Physique des Microstructures (IPM RAS),
    portait sur la photonique et le magnetotransport
    dans des puits quantiques HgTe/HgCdTe.

    Ces hétérostructures peuvent avoir une double utilité
    selon leur configuration :
    des émetteurs et détecteurs pour l'infrarouge lointain,
    ou des isolants topologiques
    avec des états de bord protégés.
    //
    À l'IPM RAS,
    j'ai étudié leur potentiel
    en tant qu'émetteurs et détecteurs pour l'infrarouge lointain,
    en utilisant
    la photoconductivité et la photoluminescence.
    // dans le THz et l'IR.
    //
    Au L2C,
    j'ai exploré leurs états d'isolants topologiques et leurs transitions,
    en utilisant la détection THz et des mesures de magnetotransport.

    Ce travail a conduit
    à la première observation d'une transition de phase topologique
    dans ces hétérostructures
    par magnetotransport,
    ainsi qu'à des longueurs d'émission laser record,
    avec des résultats publiés dans des revues
    telles que Nature Communications, PRL, PRB, et APL.

    == Mesures de Haute Précision au LNE

    Après avoir terminé ma thèse,
    je suis passé à la recherche appliquée
    et ai travaillé pendant deux ans
    au Laboratoire national de métrologie et d'essais (LNE)
    en tant qu'Ingénieur de Recherche.
    //
    Là-bas,
    j'ai continué à explorer les propriétés de magnetotransport des systèmes 2D,
    et j'ai effectué des mesures de haute précision
    et à faible bruit
    de l'effet Hall quantique dans le graphène.

    Mes contributions comprenaient :
    - l'automatisation des mesures
      à l'aide d'un système d'orchestration basé sur Python,
    - la nanofabrication de structures graphène/hBN,
    - et l'optimisation des systèmes de mesure cryogéniques
      pour réduire les coûts,
      en améliorant la récupération d'hélium
      et en mettant en œuvre un système cryogénique fiable sans hélium liquide.

    == Innovation THz chez Multitel ASBL

    Ensuite,
    j'ai passé plus de trois ans
    en tant qu'Ingénieur de Recherche chez Multitel ASBL,
    un centre d'innovation sans but lucratif,
    où j'ai dirigé les activités térahertz
    de spectroscopie dans le domaine temporel THz (THz-TDS)
    et d'imagerie.
    //
    Là-bas,
    j'ai développé des solutions basées sur le THz
    pour des applications industrielles
    comme le contrôle qualité non destructif
    de l'humidité, de l'épaisseur ou de la composition
    dans des industries telles que la pharmacie, les polymères et la biotechnologie.

    À cette fin,
    j'ai développé de nouvelles méthodes
    et amélioré les méthodes existantes
    pour extraire des informations à partir de données THz-TDS,
    y compris :
    - une estimation préliminaire et rapide de l'épaisseur
      et de l'indice de réfraction dans des échantillons faiblement absorbants,
    - et un filtrage optimisé, basé sur la courbe de sensibilité,
      avec un meilleur rapport signal/bruit.

    J'ai également mis en place une infrastructure
    pour une recherche reproductible,
    en développant des outils Python pour l'intégration d'instruments,
    la gestion des données FAIR
    (findable, accessible, interoperable, reusable),
    et des pipelines d'analyse de données automatisés.

    Grâce à ce travail,
    j'ai acquis une expérience pratique en développement logiciel,
    y compris le développement piloté par les tests,
    l'automatisation des pipelines CI/CD,
    et la conteneurisation basée sur Docker.

    == Et ensuite ?

    Je suis maintenant à la recherche de nouvelles opportunités
    pour mettre à profit mes compétences d'Ingénieur de Recherche
    et contribuer à des projets impactants.
    //
    Cela pourrait-il être avec votre équipe ?

    Je vous remercie pour votre temps et votre considération.

    Cordialement, \
    #name
  ]
]
