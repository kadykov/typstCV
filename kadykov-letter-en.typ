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
#show: setup-style.with()

#set text(hyphenate: true)

#let from-content = [
  Mons,
  Belgium

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

    = Letter to Future Employer

    Dear Future Employer,

    In this open letter,
    I would like to give you a bird's-eye view
    of my career path.

    == Photonics & Magnetotransport in L2C & IPM RAS

    I am a Research Engineer,
    and I started my journey in basic research.
    //
    My Ph.D.,
    a collaboration between
    Laboratoire Charles Coulomb (L2C)
    and Institute for Physics of Microstructures (IPM RAS),
    focused on photonics and magnetotransport
    in HgTe/HgCdTe quantum wells.

    // Depending on the configuration,
    // these heterostructures could serve
    // as far-infrared emitters and detectors
    // or topological insulators
    // with protected edge states.

    At IPM RAS,
    I studied photoconductivity and photoluminescence
    in these heterostructures
    to use them as detectors and emitters in the far-infrared range.
    //
    At L2C,
    the main focus was
    on the topological insulator state
    in these heterostructures
    and how to explore
    topological phase transitions
    by THz detection or magnetotransport measurements.

    As a result,
    the topological phase transition
    in these heterostructures
    was first observed by magnetotransport,
    and laser emission at a record-breaking wavelength was obtained.
    //
    The most impressive results
    were published in high-impact journals like
    Nature Communications, PRL, PRB, APL, etc.

    == High-Precision Measurements in LNE

    After finishing my Ph.D.,
    I moved to applied research
    and worked for two years
    in the French National Laboratory of Metrology and Testing (LNE)
    as a Research Engineer.
    //
    There,
    I continued to explore magnetotransport properties
    of 2D systems
    and gained hands-on experience
    by conducting
    state-of-the-art
    low-noise and high-precision
    metrological measurements
    of the quantum Hall effect in graphene.

    One of my main contributions
    was the automation of measurements
    by implementing an orchestration software
    based on PyMeasure in Python.
    //
    I also worked
    to decrease the costs of cryogenic measurements
    by optimizing the helium recuperation system
    and improving the reliability
    of a dry helium-free cryogenic system.

    == THz Innovations in Multitel

    Then,
    I continued my career in applied research
    and worked for more than three years
    as a Research Engineer in Multitel ASBL,
    a non-profit innovation center.
    //
    There,
    I led THz time-domain spectroscopy (THz-TDS) and imaging activities,
    developing THz-based solutions
    for industrial applications
    like non-destructive quality control
    of humidity, thickness, or composition
    in pharmaceutical, polymer, or biological samples.

    As a result,
    I developed new
    and improved existing
    ways to extract information
    from THz-TDS data,
    such as computationally cheap
    preliminary estimation
    of thickness and refractive index
    in low-absorption samples
    or sensitivity curve-shaped filtering
    with enhanced signal-to-noise ratio.

    I also implemented
    infrastructure for reliable research,
    including Python tools
    for instrument integration and measurement orchestration,
    a FAIR
    (findable, accessible, interoperable, and reusable)
    data management system,
    and a reproducible data analysis and reporting system.

    As programming has always been a big part of my job,
    I gained experience
    in test-driven development,
    documentation writing,
    automation with CI/CD pipelines,
    and containerization with Docker.

    == What's Next?

    Now,
    I'm looking forward
    to new opportunities
    to use my skills and experience
    as a Research Engineer
    to advance the world for a better future.
    //
    Maybe in your team?

    Thank you for your attention.

    Best regards,\
    #name
  ]
]
