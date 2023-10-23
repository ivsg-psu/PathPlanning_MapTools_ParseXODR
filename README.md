
<!--
*** To avoid retyping too much info. Do a search and replace for the following:
*** github_username, repo_name, twitter_handle, email, project_title, project_description
-->



<!-- PROJECT SHIELDS -->
<!--
*** I'm using markdown "reference style" links for readability.
*** Reference links are enclosed in brackets [ ] instead of parentheses ( ).
*** See the bottom of this document for the declaration of the reference variables
*** for contributors-url, forks-url, etc. This is an optional, concise syntax you may use.
*** https://www.markdownguide.org/basic-syntax/#reference-style-links
-->
[![Contributors][contributors-shield]][contributors-url]
[![Forks][forks-shield]][forks-url]
[![Stargazers][stars-shield]][stars-url]
[![Issues][issues-shield]][issues-url]
[![MIT License][license-shield]][license-url]



<!-- PROJECT LOGO -->
<br />
<p align="center">
  <!-- <a href="https://github.com/ivsg-psu/FieldDataCollection_RoadSegments_ParseXODR">
    <img src="images/logo.png" alt="Logo" width="80" height="80">
  </a> -->

  <h3 align="left">FieldDataCollection_RoadSegments_ParseXODR Repository</h3>

  <p align="left">
    MATLAB code implementation of a series of functions that read in OpenDRIVE *.xodr files, check for errors against the OpenDRIVE specification, and parse the XML-coded geometries into MATLAB structures that can be analyzed, modified, and plotted using other existing code.
    <br />
    <a href="https://github.com/ivsg-psu/FieldDataCollection_RoadSegments_ParseXODR/tree/main/Documents"><strong>Explore the docs »</strong></a>
    <br />
  </p>
</p>



<!-- TABLE OF CONTENTS -->
<details open="open">
  <summary><h2 style="display: inline-block">Table of Contents</h2></summary>
  <ol>
    <li>
      <a href="#about-the-project">About The Project</a>
    </li>
    <li>
      <a href="#getting-started">Getting Started</a>
      <ul>
        <li><a href="#installation">Installation</a></li>
      </ul>
    </li>
    <li><a href="structure">Repo Structure</a>
	    <ul>
	    <li><a href="#directories">Top-Level Directories</li>
	    <li><a href="#functions">Functions</li>
	    </ul>
    </li>
    <li><a href="#usage">Usage</a></li>
    <li><a href="#license">License</a></li>
    <li><a href="#contact">Contact</a></li>
  </ol>
</details>



<!-- ABOUT THE PROJECT -->
## About The Project

<!--[![Product Name Screen Shot][product-screenshot]](https://example.com)-->

The OpenDRIVE standard defines a rigorous XML-based approach to describing a roadway environment. This environment includes a centerline path of the road that may include straight line segments, clothoid curves, constant arcs, and custom polynomial segments. The centerline serves as a reference to build from, and defined from this centerline are lanes, which have ordering, widths, and can even have offset or "sway" relative to the road centerline. Using just these concepts, individual roads can be defined with substantially complex geometry. Additionally, objects can be added to the environment. The objects are defined relative to the coordinates of the road centerline and can be described generally by a circular or rectangular "bounding box" or more specifically using vertices of the object itself.

Key in the parsing process are transformations between parametric descriptions of the environment and point-based representations as well as between path (s,t) coordinates and local (east, north) coordinates. Parametric description is used primarily in the XML files, while point-based representations are more favorable in the MATLAB environment, particularly in the PSU path library and obstacle/patch library. Similarly, path coordinates are used to define roads efficiently while local coordinates are needed for many spatial analyses and plotting.

The library of functions described in the following sections provide the needed functionality in this conversion from OpenDRIVE *.xodr to the MATLAB environment.


<!-- STRUCTURE OF THE REPO -->
## Structure
### Directories
The following are the top level directories within the repository:
<ul>
	<li>Data: XODR source files to use as input to the various functions in the repository.</li>
	<li>Documents: Descriptions of the functionality and usage of the various MATLAB functions and scripts in the repository.</li>
	<li>Functions: The majority of the code for the point and patch association functionalities are implemented in this directory. All functions as well as test scripts are provided.</li>
	<li>Utilities: Dependencies that are utilized but not implemented in this repository are placed in the Utilities directory. These can be single files but are most often other cloned repositories.</li>
</ul>

<!-- FUNCTION DEFINITIONS -->
### Functions
<ul>
	<li>fcn_RoadSeg_convertXODRtoMATLABStruct: A wrapper function to manage the conversion of the XML file into a MATLAB structure. Depends on MathWorks file exchange contribution "xml2struct_fex28518" which is included (statically) in the ParseXODR library. Accepts a filename for an *.xodr file and returns a MATLAB structure with the OpenDrive elements in hierarchical arrangement.</li>
	<li>fcn_RoadSeg_XODRSegmentChecks: A function that provides checking of a MATLAB structure (and fixes, where possible) to ensure congruency with the OpenDRIVE standard. </li>
	<li>fcn_RoadSeg_extractLaneGeometry: A function that utilizes the road centerline plus lane descriptions in the XODR file to produce a set of traversals, consistent with the PSU Path Library, which describe the lanes of the roadway.</li>
	<li>fcn_RoadSeg_findXYfromSTandSegment: A wrapper function that extracts the geometry descriptors for a road segment and calls fcn_RoadSeg_findXYfromST with the appropriate arguments for the road  segment. The function returns the local (X,Y) (or E,N) coordinates associated with the (s,t) coordinates along the segment.</li>
	<li>fcn_RoadSeg_findXYfromST: A function that utilizes the road segment description and returns the local (X,Y) (or E,N) coordinates associated with the (s,t) coordinates along the segment. </li>
	<li>fcn_RoadSeg_findXYfromXODRArc: A function that determines the (X,Y) coordinates associated with a set of s-coordinates along an arc road centerline segment with arguments consistent with the OpenDRIVE standard. </li>
	<li>fcn_RoadSeg_findXYfromXODRSpiral: A function that determines the (X,Y) coordinates associated with a set of s-coordinates along an arc road centerline segment with arguments consistent with the OpenDRIVE standard.</li>
	<li>fcn_RoadSeg_convertXODRObjectsToPatchObjects: A function that extracts object descriptions from an OpenDRIVE file and returns a structure array of patch objects consistent with the PSU Patch library. Each object is defined by its vertices, either coming from the vertices provided in the OpenDRIVE description, or via points placed on the perimeter of the circular or rectangular bounding "box."</li>
</ul>

<!-- SCRIPT DEFINITIONS -->
### Test Scripts
<ul>
	<li>script_test_fcn_RoadSeg_parsingProcess: Tests the functionality of the overall parsing process, using several functions from the ParseXODR library as well as some other PSU libraries.</li>
	<li>script_test_fcn_RoadSeg_findXYfromXODRArc.m: Tests the functionality of the mid-level function findXYfromXODRArc.m</li>
	<li>script_test_fcn_RoadSeg_findXYfromXODRSpiral.m: Tests the functionality of the mid-level function findXYfromXODRSpiral.m</li>
	<li>script_test_fcn_RoadSeg_findXYfromST.m: Tests the functionality of the low level function findXYfromST.m</li>
</ul>

<!-- GETTING STARTED -->
## Getting Started

To get a local copy up and running follow these simple steps.

### Installation

1. Clone the repo
   ```sh
   git clone https://github.com/ivsg-psu/FieldDataCollection_RoadSegments_ParseXODR.git
   ```


<!-- USAGE EXAMPLES -->
## Usage
<!-- Use this space to show useful examples of how a project can be used.
Additional screenshots, code examples and demos work well in this space. You may
also link to more resources. -->

1. Open MATLAB and navigate to the Functions directory

2. Run any of the various test scripts, such as
   ```sh
   script_test_fcn_RoadSeg_parsingProcess
   ```
For more examples, please refer to the [Documentation] 

https://github.com/ivsg-psu/FieldDataCollection_RoadSegments_ParseXODR/tree/main/Documents



<!-- LICENSE -->
## License

Distributed under the MIT License. See `LICENSE` for more information.



<!-- CONTACT -->
## Contact

Your Name - [@twitter_handle](https://twitter.com/twitter_handle) - email

Project Link: [https://github.com/ivsg-psu/FieldDataCollection_RoadSegments_ParseXODR](https://github.com/ivsg-psu/FieldDataCollection_RoadSegments_ParseXODR)



<!-- MARKDOWN LINKS & IMAGES -->
<!-- https://www.markdownguide.org/basic-syntax/#reference-style-links -->
[contributors-shield]: https://img.shields.io/github/contributors/ivsg-psu/FieldDataCollection_RoadSegments_ParseXODR.svg?style=for-the-badge
[contributors-url]: https://github.com/ivsg-psu/FieldDataCollection_RoadSegments_ParseXODR/graphs/contributors
[forks-shield]: https://img.shields.io/github/forks/ivsg-psu/FieldDataCollection_RoadSegments_ParseXODR.svg?style=for-the-badge
[forks-url]: https://github.com/ivsg-psu/FieldDataCollection_RoadSegments_ParseXODR/network/members
[stars-shield]: https://img.shields.io/github/stars/ivsg-psu/FieldDataCollection_RoadSegments_ParseXODR.svg?style=for-the-badge
[stars-url]: https://github.com/ivsg-psu/FieldDataCollection_RoadSegments_ParseXODR/stargazers
[issues-shield]: https://img.shields.io/github/issues/ivsg-psu/FieldDataCollection_RoadSegments_ParseXODR.svg?style=for-the-badge
[issues-url]: https://github.com/ivsg-psu/FieldDataCollection_RoadSegments_ParseXODR/issues
[license-shield]: https://img.shields.io/github/license/ivsg-psu/FieldDataCollection_RoadSegments_ParseXODR.svg?style=for-the-badge
[license-url]: https://github.com/ivsg-psu/FieldDataCollection_RoadSegments_ParseXODR/blob/master/LICENSE.txt
