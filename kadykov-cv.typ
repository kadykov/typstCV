#import "style.typ": *

#let name = "Aleksandr Kadykov"
#let post-name = "Research Engineer"
#let website = "www.kadykov.com"
#let github = "kadykov"
#let gitlab = "kadykov"
#let linkedin = "aleksandr-kadykov"

// Optional email input
#let email = {
  if "EMAIL" in sys.inputs.keys() {sys.inputs.EMAIL}
  else {"cv@kadykov.com"}
}

// Call the function from `style.typ` and pass variables to set up the document style
#show: setup-style.with(
  name: name,
  email: email,
  website: website,
  github: github,
  gitlab: gitlab,
  linkedin: linkedin,
)

// Main content starts here
#block(width: 100%)[
  #box(width: calc.min(bodywidth, 70%))[
    = #post-name

    Proven ability to design and execute experiments, develop data
    processing methods, and automate workflows in scientific environments.
    Strong background in
    THz and IR
    applied photonics,
    solid-state physics,
    cryogenic measurements,
    data analysis,
    signal processing,
    and instrumentation integration.
  ]
  #place(top + right)[
    #box(
      clip: true,
      stroke: 1.5pt + primary-color,
      radius: (
        bottom-left: 0%,
        bottom-right: 50%,
        top-left: 50%,
        top-right: 0%,
      ),
    )[
      #image(
        "photo.jpg",
        width: 25%,
      )
    ]
  ]
]

#hidden-section()[
  Core competencies
]

#block(
width: calc.min(bodywidth, 70%),
)[
  #secline()

  - Experimental design & execution
  - Instrumentation integration & automation
  - Data analysis & signal processing
  - #link("https://github.com/search?q=language%3APython+author%3Akadykov&type=pullrequests"
    )[Python] programming
  - THz & IR photonics
  - Solid-state physics
]

#hidden-section()[
  Professional experience
]

#experience(
  company-title: [
    #link("https://www.multitel.eu/expertise/applied-photonics/terahertz-spectroscopy-and-imaging/"
    )[Multitel ASBL]
  ],
  company-subtitle: [
    Non-profit
    innovation center specializing in
    #link("https://www.multitel.eu/expertise/applied-photonics/"
    )[applied photonics],
    #link("https://www.multitel.eu/expertise/artificial-intelligence/"
    )[AI],
    etc.
  ],
  dates: [Jul.~2021 \ Aug.~2024],
  company-location: [
    #link("https://www.openstreetmap.org/#map=19/50.45756/3.92540"
    )[Mons \ Belgium]
  ],
)[
  === Research Engineer in THz Spectroscopy and Imaging

  - Developed advanced methods for THz-TDS data processing, improving
    results extraction for the
    #link("https://www.multitel.eu/projects/tera4all/"
    )[TERA4ALL] project.
  - Offloaded Transfer Matrix Method (TMM)
    calculations to a GPU, significantly enhancing refraction index
    profile extraction.
  - Automated laboratory workflows by implementing
    Python tools for measurement
    orchestration, data management, analysis, and result presentation.
  - Led the #link("https://www.multitel.eu/projects/saphire/")[SAPHIRE]
    project, developing THz-based _in-situ_ solutions for pill coating
    thickness and humidity control.
  - Ensured robust software development practices by incorporating unit
    testing, CI/CD pipelines, and comprehensive documentation.
]

#experience(
  company-title: [
    #link("https://www.lne.fr/en/research-and-development"
    )[Laboratoire National de Métrologie et d'Essais (LNE)]
  ],
  company-subtitle: [
    French National Laboratory of Metrology and Testing
  ],
  dates: [Sep.~2018\ Sep.~2020],
  company-location: [
    #link("https://www.openstreetmap.org/#map=17/48.76090/1.98370"
    )[
      Trappes \
      France
    ]
  ]
)[
  === Research Engineer in Quantum Hall Effect Metrology

  - Led low-noise cryogenic quantum Hall measurements on graphene,
    exploring its potential as a resistance standard.
  - Designed a flexible Python software
    package using PyMeasure,
    optimizing scientific equipment orchestration.
  - Participated in the nanofabrication of hBN-encapsulated graphene
    samples, advancing quantum Hall research.
]

#experience(
  company-title: [
    #link("http://www.ipmras.ru/en/institute/scientific-departments/department-110/"
    )[Institute for Physics of Microstructures (IPM RAS)]
  ],
  company-subtitle: [
    State-owned research institute
    specializing in solid state physics.
  ],
  company-location: [
    #link("https://www.openstreetmap.org/#map=17/56.29878/43.97990"
    )[Nizhny Novgorod \ Russia]
  ],
  dates: [May~2017 \ Sep.~2018],
)[
  === Research Engineer in Photonics of Narrow-Gap Semiconductors

  - Conducted THz and FTIR cryogenic measurements of photoluminescence and
    photoconductivity.
  - Achieved laser emission in HgCdTe heterostructures at
    #link("https://doi.org/10.1063/1.4996966")[a record wavelength].
]

#hidden-section()[
  Education
]

#experience(
  company-title: [
    #link("https://coulomb.umontpellier.fr/?lang=en"
    )[Laboratoire Charles Coulomb (L2C)]
    &
    #link("http://www.ipmras.ru/en/institute/scientific-departments/department-110/"
    )[IPM RAS]
  ],
  company-subtitle: [
    #link("https://edi2s.umontpellier.fr/"
    )[I2S Doctorlal School]
    at the
    #link("https://www.umontpellier.fr/en/"
    )[University of Montpellier]
  ],
  company-location: [
    #link("https://www.openstreetmap.org/#map=18/43.63339/3.86312"
    )[Montpellier, France]
    \
    #link("https://www.openstreetmap.org/#map=17/56.29878/43.97990"
    )[Nizhny Novgorod, Russia]
  ],
  dates: [Sep.~2014 \ Dec.~2017],
)[

  === Ph.D.~in Physics

  Thesis:
  #link("https://www.theses.fr/en/2017MONTS086")[
    Physical properties of HgCdTe-based heterostructures:
    towards terahertz emission and detection
  ]

  - Implemented a double-modulation technique, enabling the extraction of
    critical magnetic fields in a topological insulator.
  - First to observe
    #link("https://dx.doi.org/10.1103/PhysRevLett.120.086401")[a temperature-driven phase transition]
    in a topological insulator using magnetotransport.
]

#secline()
== Technical skills

- *Programming & data analysis*:
  #link("https://www.python.org/")[Python],
  #link("https://jupyter.org/")[Jupyter],
  #link("https://numpy.org/")[NumPy],
  #link("https://pandas.pydata.org/")[Pandas],
  #link("https://xarray.dev/")[Xarray], SciPy,
  #link("https://docs.pytest.org/")[PyTest],
  #link("https://pytorch.org/")[PyTorch],
  #link("https://scikit-learn.org/")[scikit-learn],
  #link("https://www.mathworks.com/products/matlab.html")[MATLAB]
- *Data visualization*:
  #link("https://matplotlib.org/")[Matplotlib],
  #link("https://hvplot.holoviz.org/")[hvPlot],
  #link("https://plotly.com/python/")[Plotly],
  #link("https://bokeh.org/")[Bokeh],
  #link("https://panel.holoviz.org/")[Panel],
  #link("https://www.originlab.com/")[OriginPro]
- *Measurement & automation*:
  #link("https://pymeasure.readthedocs.io")[PyMeasure],
  #link("https://blueskyproject.io/")[Bluesky],
  #link("https://yaq.fyi/")[yaq],
  #link("https://www.ni.com/en/shop/labview.html")[LabVIEW]
- *Data management & integration*:
  #link("https://intake.readthedocs.io")[Intake],
  #link("https://en.wikipedia.org/wiki/SQL")[SQL]
- *Document preparation*:
  #link("https://quarto.org/")[Quarto],
  #link("https://github.com/search?q=owner%3Akadykov+language%3ATypst&type=repositories"
  )[Typst],
  #link("https://pandoc.org/")[Pandoc],
  #link("https://www.latex-project.org/")[LaTeX]
- *Other tools*:
  #link("https://code.visualstudio.com/")[VSCode],
  #link("https://git-scm.com/")[Git],
  #link("https://www.linux.com/what-is-linux/")[Linux],
  #link("https://www.docker.com/")[Docker],
  #link("https://about.gitlab.com/topics/ci-cd/")[CI/CD],
  #link("https://www.zotero.org/")[Zotero],
  #link("https://github.com/kadykov/")[GitHub],
  #link("https://gitlab.com/kadykov/")[GitLab],
  #link("https://en.wikipedia.org/wiki/Test-driven_development")[TDD]

#secline()
== Languages

- *French* (#link("https://www.duolingo.com/profile/aleksandrkadykov"
    )[upper-intermediate]
  )
- *Russian* (native)

// #secline()
// = Selected publications

// + Kadykov, A.M., Torres, J., Krishtopenko, S.S. et al.,
//   #link("https://dx.doi.org/10.1063/1.4955018")[_Terahertz imaging of Landau levels in HgTe-based topological insulators_],
//   *Applied Physics Letters*, 108(26), _262102_, 2016
// + Teppe, F., Marcinkiewicz, M., Krishtopenko, S.S. et al.,
//   #link("https://dx.doi.org/10.1038/ncomms12576")[_Temperature-driven massless Kane fermions in HgCdTe crystals_],
//   *Nature Communications*, 7, _12576_, 2016
// + Kadykov, A.M., Krishtopenko, S.S., Jouault, B. et al.,
//   #link("https://dx.doi.org/10.1103/PhysRevLett.120.086401")[_Temperature-Induced Topological Phase Transition in HgTe Quantum Wells_],
//   *Physical Review Letters*, 120(8), _086401_, 2018
// + Kadykov, A.M., Teppe, F., Consejo, C. et al.,
//   #link("https://dx.doi.org/10.1063/1.4932943")[_Terahertz detection of magnetic field-driven topological phase transition in HgTe-based transistors_],
//   *Applied Physics Letters*, 107(15), _152101_, 2015
// + Krishtopenko, S.S., Ruffenach, S., Gonzalez-Posada, F. et al.,
//   #link("https://dx.doi.org/10.1103/PhysRevB.97.245419")[_Temperature-dependent terahertz spectroscopy of inverted-band three-layer InAs / GaSb / InAs quantum well_],
//   *Physical Review B*, 97(24), _245419_, 2018
// + Ruffenach, S., Kadykov, A.M., Rumyantsev, V.V. et al.,
//   #link("https://dx.doi.org/10.1063/1.4977781")[_HgCdTe-based heterostructures for terahertz photonics_],
//   *APL Materials*, 5(3), _035503_, 2017
// + Yahniuk, I., Krishtopenko, S.S., Grabecki, G. et al.,
//   #link("https://dx.doi.org/10.1038/s41535-019-0154-3")[_Magneto-transport in inverted HgTe quantum wells_],
//   *npj Quantum Materials*, 4(1), _1--8_, 2019
// + Marcinkiewicz, M., Ruffenach, S., Krishtopenko, S.S. et al.,
//   #link("https://dx.doi.org/10.1103/PhysRevB.96.035405")[_Temperature-driven single-valley Dirac fermions in HgTe quantum wells_],
//   *Physical Review B*, 96(3), _035405_, 2017
// + Morozov, S.V., Rumyantsev, V.V., Fadeev, M. et al.,
//   #link("https://dx.doi.org/10.1063/1.4996966")[_Stimulated emission from HgCdTe quantum well heterostructures at wavelengths up to 19.5~μm_],
//   *Applied Physics Letters*, 111(19), _192101_, 2017
// + Morozov, S.V., Rumyantsev, V.V., Kadykov, A.M. et al.,
//   #link("https://dx.doi.org/10.1063/1.4943087")[_Long wavelength stimulated emission up to 9.5~μm from HgCdTe quantum well heterostructures_],
//   *Applied Physics Letters*, 108(9), _092104_, 2016
// + Morozov, S.V., Rumyantsev, V.V., Dubinov, A.A. et al.,
//   #link("https://dx.doi.org/10.1063/1.4926927")[_Long wavelength superluminescence from narrow gap HgCdTe epilayer at 100~K_],
//   *Applied Physics Letters*, 107(4), _042105_, 2015
// + Morozov, S.V., Rumyantsev, V.V., Antonov, A. et al.,
//   #link("https://dx.doi.org/10.1063/1.4890416")[_Time resolved photoluminescence spectroscopy of narrow gap Hg1-xCdxTe/CdyHg1-yTe quantum well heterostructures_],
//   *Applied Physics Letters*, 105(2), _022102_, 2014
// + Rumyantsev, V.V., Kozlov, D.V., Morozov, S.V. et al.,
//   #link("https://dx.doi.org/10.1088/1361-6641/aa76a0")[_Terahertz photoconductivity of double acceptors in narrow gap HgCdTe epitaxial films grown by molecular beam epitaxy on GaAs(013) and Si(013) substrates_],
//   *Semiconductor Science and Technology*, 32(9), _095007_,
//   2017
// + Fadeev, M.A., Rumyantsev, V.V., Kadykov, A.M. et al.,
//   #link("https://dx.doi.org/10.1364/OE.26.012755")[_Stimulated emission in the 2.8--3.5~μm wavelength range from Peltier cooled HgTe/CdHgTe quantum well heterostructures_],
//   *Optics Express*, 26(10), _12755_, 2018
// + Kadykov, A.M., Consejo, C., Marcinkiewicz, M. et al.,
//   #link("https://dx.doi.org/10.1002/pssc.201510264")[_Observation of topological phase transition by terahertz photoconductivity in HgTe-based transistors_],
//   *physica status solidi (c)*, 13(7), _534--537_, 2016
// + Kadykov, A.M., Consejo, C., Teppe, F. et al.,
//   #link("https://dx.doi.org/10.1088/1742-6596/647/1/012009")[_Terahertz excitations in HgTe-based field effect transistors_],
//   *Journal of Physics: Conference Series*, 647(1),
//   _012009_, 2015
// + Bovkun, L.S., Krishtopenko, S.S., Ikonnikov, A.V. et al.,
//   #link("https://dx.doi.org/10.1134/S1063782616110063")[_Magnetospectroscopy of double HgTe/CdHgTe quantum wells_],
//   *Semiconductors*, 50(11), _1532--1538_, 2016
// + Aleshkin, V.Y., Gavrilenko, L.V., Gaponova, D.M. et al.,
//   #link("https://dx.doi.org/10.1134/S1063776113130013")[_Nonresonant radiative exciton transfer by near field between quantum wells_],
//   *Journal of Experimental and Theoretical Physics*, 117(5),
//   _944--949_, 2013
// + Morozov, S.V., Rumyantsev, V.V., Kadykov, A.M. et al.,
//   #link("https://dx.doi.org/10.1088/1742-6596/647/1/012008")[_Investigation of possibility of VLWIR lasing in HgCdTe based heterostructures_],
//   *Journal of Physics: Conference Series*, 647(1),
//   _012008_, 2015
// + Kozlov, D.V., Rumyantsev, V.V., Morozov, S.V. et al.,
//   #link("https://dx.doi.org/10.1134/S1063782615120106")[_Impurity-induced photoconductivity of narrow-gap Cadmium--Mercury--Telluride structures_],
//   *Semiconductors*, 49(12), _1605--1610_, 2015
// + Rumyantsev, V.V., Fadeev, M.A., Morozov, S.V. et al.,
//   #link("https://dx.doi.org/10.1134/S1063782616120174")[_Long-wavelength stimulated emission and carrier lifetimes in HgCdTe-based waveguide structures with quantum wells_],
//   *Semiconductors*, 50(12), _1651--1656_, 2016
// + Ikonnikov, A.V., Bovkun, L.S., Rumyantsev, V.V. et al.,
//   #link("https://dx.doi.org/10.1134/S1063782617120090")[_On the band spectrum in p-type HgTe/CdHgTe heterostructures and its transformation under temperature variation_],
//   *Semiconductors*, 51(12), _1531--1536_, 2017
// + Rumyantsev, V.V., Kadykov, A.M., Fadeev, M.A.~et al.,
//   #link("https://dx.doi.org/10.1134/S106378261712017X")[_Investigation of HgCdTe waveguide structures with quantum wells for long-wavelength stimulated emission_],
//   *Semiconductors*, 51(12), _1557--1561_, 2017
// + Krishtopenko, S.S., Ikonnikov, A.V., Maremyanin, K.V. et al.,
//   #link("https://dx.doi.org/10.1134/S1063782617010109")[_Cyclotron resonance of Dirac fermions in InAs/GaSb/InAs quantum wells_],
//   *Semiconductors*, 51(1), _38--42_, 2017
// + Kozlov, D.V., Rumyantsev, V.V., Morozov, S.V. et al.,
//   #link("https://dx.doi.org/10.1134/S1063782616120113")[_Mercury vacancies as divalent acceptors in Hg1-xCdxTe/CdyHg1-yTe structures with quantum wells_],
//   *Semiconductors*, 50(12), _1662--1668_, 2016
// + Rumyantsev, V.V., Bovkun, L., Kadykov, A.M. et al.,
//   #link("https://dx.doi.org/10.1134/S1063782618040255")[_Magnetooptical Studies and Stimulated Emission in Narrow Gap HgTe/CdHgTe Structures in the Very Long Wavelength Infrared Range_],
//   *Semiconductors*, 52(4), 2018
// + Kadykov, A.M., Teppe, F., Consejo, C. et al.,
//   #link("http://mmi.univ-savoie.fr/agence/8thzdays/siteANG/")[_Terahertz excitations in HgTe-based field effect transistors_],
//   _113--114_, 2015
// + Gavrilenko, V.I., Morozov, S.V., Rumyantsev, V.V. et al.,
//   #link("https://dx.doi.org/10.1109/MIKON.2016.7492017")[_THz lasers based on narrow-gap semiconductors_],
//   _1--4_, 2016
// + Marcinkiewicz, M., Krishtopenko, S.S., Ruffenach, S. et al.,
//   #link("https://dx.doi.org/10.1109/IRMMW-THz.2016.7758790")[_THz magnetospectroscopy of double HgTe quantum well_],
//   _1--2_, 2016
// + Morozov, S.V., Rumyantsev, V.V., Kadykov, A.M. et al.,
//   #link("https://dx.doi.org/10.1109/IRMMW-THz.2016.7758927")[_Long-wavelength stimulated emission in HgCdTe quantum well waveguide heterostructures_],
//   2016-Novem, _1--2_, 2016
// + But, D.B., Consejo, C., Krishtopenko, S.S. et al.,
//   #link("https://dx.doi.org/10.1109/IRMMW-THz.2016.7758889")[_Terahertz cyclotron emission from HgCdTe bulk films_],
//   2016-Novem, _1--2_, 2016
// + Yahniuk, I., Krishtopenko, S.S., Grabecki, G. et al.,
//   _Graphene-like band structure (Hg, Cd) Te Quantum Wells for
//   Quantum Hall Effect Metrology Applications_, _229_, 2017
