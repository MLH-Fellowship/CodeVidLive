# CodeVid Live

**CodeVid Live** is a mobile application that allows its users to estimate the **probability of contamination** of corona virus if they stay at a particular area. This way the users can plan their travel routes, by knowing ahead of time to avoid routes where the probability of contamination is high. The same feature can be used by government and health care organizations to identify hot spots of contamination and take better and early measures for quarantine, preparation of medical supplies including provision of ventilators, quarantine wards etc.

## Problem

In December 2019, there was a cluster of pneumonia cases in China. Investigations found that it was caused by a previously unknown virus now named the Novel Coronavirus 2019. Since its first discovery, the global impact of the coronavirus has been profound, significantly changing the lifestyle of people around the world. Initially, the governments' combat plan against the virus was to have a lockdown, however, the economy of any country cannot bear the prolonged lockdown without crashing. As a result, employees of several industries such as manufacturing, health care etc. have no choice but to go outside their homes to their workplaces. If left as is, coronavirus will spread very quickly and herd immunity maybe the only option especially for underdeveloped countries.
The question arises whether we can make the travel and period outside less prone to infection thereby, reducing the spread of coronavirus to controllable levels. Framed nicely, the question is "What is the probability of me getting infected if I stay at a specific place for some timeframe?".

## Features/Use Cases

A list of documented use cases can be found [here](https://github.com/MLH-Fellowship/CodeVidLive/issues/1). A quick overview of features is given below:

- Predict chance of exposure to COVID-19.
- Identify hot spots of exposure of COVID-19.
- API availability of the model to developers and healthcare organizations.


## Getting started

### Prerequisites

#### Julia
Install Julia and include in system path

```bash
julia setup.jl
```

#### Flutter
For help getting started with Flutter, view their [online documentation](https://flutter.dev/docs), which offers tutorials.

### Setup Genie server
To run in interactive mode
```bash
cd genie_app/bin
repl
```
OR

To run in non-interactive mode
```bash
cd genie_app/bin
server
```

### Build flutter app
```cmd
flutter run
```

## Technology Stack

- __Julia__: High level programming language for numerical analysis and computational sciences.
- __Pathogen.jl__: Infectious Disease Transmission Network Modelling with Julia.
- __Genie.jl__: The highly productive Julia framework.
- __JuliaDB.jl__: A package for working with persistent datasets.
- __Flutter__: Open source, cross-platform UI software development kit.
- __charts_flutter__: Material Design data visualization library written natively in Dart.
- __google_maps_flutter__: A Flutter plugin that provides Google Maps widget.
- __DigitalOcean__: IAAS provider for deployment.

## Algorithm
The problem statement is to give an estimation of chance being infected by the coronavirus given map coordinates and time frame. For instance, I may want an estimation of me being infected given the condition that Hamilton Hospital has a coronavirus case while I am at Auckland Airport, New Zealand with a 48 hour timeframe window.
To calculate the transmission of virus from Hamilton Hospital to Auckland Airport, imagine yourselves as a virus who is using Google Maps to reach from Hamilton Hospital to Auckland Airport, like the famous Plague Inc game but on a smaller scale.
This is exactly how the algorithm is operating. For a given set of coordinates and time frame as input, it finds the nearest __virus cluster__ and uses __Google Direct API__ to navigate to the requested location. A __composite function__ weights the various routes available with a __virus factor__ to give an __estimation__ of a chance of coronavirus infection.
The pathogen is modelled using __Pathogen.jl__
![A view of Pathogen modelling](https://github.com/MLH-Fellowship/CodeVidLive/blob/master/epianimation.gif)
