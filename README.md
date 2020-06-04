# CodeVid Live

The global impact of COVID-19 has been profound and the public health threat that it represents is the most serious seen in a respiratory virus. Here we present a mobile application **CodeVid Live** that allows its users to estimate the **probability of contamination** of corona virus if they stay at a particular area. This way the users can plan their travel routes, by knowing ahead of time to avoid routes where the probability of contamination is high. The same feature can be used by government and health care organizations to identify hot spots of contamination and take better and early measures for quarantine, preparation of medical supplies including provision of ventilators, quarantine wards etc.

## Problem

Non-pharmaceutical interventions are very necessary to combat COVID-19 especially now that forced lock-downs are no longer an option for underdeveloped countries to save their economies. We need tools that can help people, organizations and government to practice these non-pharmaceutical interventions and CodeVid Live is exactly one such tool!
It aims to solve the issue **"What is the probability of me getting infected if I go to a specific place?"** which is faced by public going for grocery shopping, employees for planning their work routes and businesses to ensure safety of their workers.

## Features/Use Cases

A list of documented use cases can be found [here](https://github.com/MLH-Fellowship/CodeVidLive/issues/1). A quick overview of features is given below:

- Predict chance of exposure to COVID-19.
- Identify hot spots of exposure of COVID-19.
- API availability of the model to developers and healthcare organizations.

## Quick Start

TBD

## Technology Stack

Julia is the primary language for backend, responsible for doing all behind the scenes calculations. Specifically, the library SciML is used for predicting the chance of exposure of COVID-19.
Flutter is being used for the frontend development of mobile applications because of its rapid prototyping and cross-platform capabilities.

## Setup Pathogen Julia

Install Julia and include in system path

```bash
julia setup.jl
```

## Run Server

1. Under the genie_app folder, run run_server.sh.
2. When prompted with julia REPL, run `up()`
