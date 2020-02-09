<!DOCTYPE html>
<!--
Copyright (C) 2013-2017 Altera Corporation, San Jose, California, USA. All rights reserved.
Permission is hereby granted, free of charge, to any person obtaining a copy of this
software and associated documentation files (the "Software"), to deal in the Software
without restriction, including without limitation the rights to use, copy, modify, merge,
publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to
whom the Software is furnished to do so, subject to the following conditions:
The above copyright notice and this permission notice shall be included in all copies or
substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
OTHER DEALINGS IN THE SOFTWARE.

This agreement shall be governed in all respects by the laws of the State of California and
by the laws of the United States of America.
-->
<html>
<head>
<meta charset="utf-8"/>
<meta http-equiv="X-UA-Compatible" content="IE=edge"/>
<title>Vector Add: Intel FPGA&reg; OpenCL&trade; Design Example</title>
<link rel="stylesheet" href="../common/readme.css" type="text/css">
</head>
<body>
<h1>
<div class="preheading">Intel FPGA<sup>&reg;</sup> OpenCL&trade; Design Example</div>
Vector Add
</h1>

<p>This readme file for the Vector Add OpenCL Design Example contains
information about the design example package. For more examples, please
visit the <a href="https://www.altera.com/products/design-software/embedded-software-developers/opencl/developer-zone.html">
Intel FPGA OpenCL Design Examples page</a>.</p>
<nav>
<h2>Contents</h2>
<ul>
<li><a href="#Description">Description</a></li>
<li><a href="#Software_Hardware_Requirements">Software &amp; Hardware Requirements</a></li>
<li><a href="#Package_Contents">Package Contents</a></li>
<li><a href="#Compiling_the_OpenCL_Kernel">Compiling the OpenCL Kernel</a></li>
<li><a href="#Compiling_the_Host_Program">Compiling the Host Program</a></li>
<li><a href="#Running_the_Host_Program">Running the Host Program</a></li>
<li><a href="#Release_History">Release History</a></li>
<li><a href="#Legal">Legal</a></li>
<li><a href="#Contacting_Intel">Contacting Intel</a></li>
</ul>
</nav>
<section>
<a id="Description"><h2>Description</h2></a>
<p>This example runs a basic OpenCL kernel that performs
      <span class="mono">C = A + B</span>
      where <span class="mono">A</span>, <span class="mono">B</span> and <span class="mono">C</span> are <span class="mono">N</span>-element vectors. The kernel is intentionally
      kept simple and not optimized to achieve maximum performance on
      the FPGA.</p><p>In addition to demonstrating the basic OpenCL API, this example supports
      partitioning the problem across multiple OpenCL devices, if available. 
      If there are <span class="mono">M</span> available devices, the problem is divided so that each device operates 
      on <span class="mono">N/M</span> points. The host program assumes that all devices are of the same type (that is, 
      the same binary can be used, but the code can be generalized to support different 
      device types easily.</p>
</section>

<section>
<a id="Software_Hardware_Requirements"><h2>Software &amp; Hardware Requirements</h2></a>
<p/>
<table class="reqs">
<thead>
<tr>
  <th rowspan="3">Requirement</th>
  <th rowspan="3">Version</th>
<th colspan="2">OpenCL Kernel</th><th colspan="4">Host Program</th></tr><tr><th rowspan="2">Hardware<br/>Compile</th><th rowspan="2">Emulation<br/>Compile</th><th colspan="2">Hardware</th><th colspan="2">Emulation</th></tr><tr><th>Compile</th><th>Run</th><th>Compile</th><th>Run</th></tr></thead><tbody><tr><td>Quartus Prime Design Software <small>(Quartus II)</small></td><td>17.0 or later</td><td class="req">&#x02713;</td><td class="req">&#x02713;</td><td></td><td></td><td></td><td></td></tr><tr><td>Intel(R) FPGA SDK for OpenCL(TM)</td><td>17.0 or later</td><td class="req">&#x02713;</td><td class="req">&#x02713;</td><td class="req" rowspan="2">&#x02713;<div class="either">(either)</div></td><td class="req" rowspan="2">&#x02713;<div class="either">(either)</div></td><td class="req" rowspan="2">&#x02713;<div class="either">(either)</div></td><td class="req" rowspan="2">&#x02713;<div class="either">(either)</div></td></tr><tr><td>Intel(R) FPGA Runtime Environment for OpenCL(TM)</td><td>17.0 or later</td><td></td><td></td></tr><tr><td>Board Support Package</td><td>17.0-compatible</td><td class="req">&#x02713;</td><td class="req">&#x02713;</td><td class="req">&#x02713;</td><td class="req">&#x02713;</td><td class="req">&#x02713;</td><td class="req">&#x02713;</td></tr><tr><td>Board Hardware</td><td>-</td><td></td><td></td><td></td><td class="req">&#x02713;</td><td></td><td></td></tr><tr><td>gcc</td><td>4.4.7 or later</td><td></td><td></td><td class="req">&#x02713;</td><td class="req">&#x02713;</td><td class="req">&#x02713;</td><td class="req">&#x02713;</td></tr><tr><td>GNU Make</td><td>3.8.1 or later</td><td></td><td></td><td class="req">&#x02713;</td><td></td><td class="req">&#x02713;</td><td></td></tr></tbody>
</table>

</section>

<section>
<a id="Package_Contents"><h2>Package Contents</h2></a>
<p/>
<table class="pkg-contents">
<thead>
<tr>
  <th class="path">Path</th>
  <th class="desc">Description</th>
</tr>
</thead>
<tbody>
<tr>
  <td class="path"><a href="./" style="padding-left: 0.0ex">vector_add/</a></td>
  <td class="desc"></td>
</tr>
<tr>
  <td class="path"><a href="./Makefile" style="padding-left: 2.0ex">Makefile</a></td>
  <td class="desc">Makefile for host program</td>
</tr>
<tr>
  <td class="path"><a href="./bin/" style="padding-left: 2.0ex">bin/</a></td>
  <td class="desc">Host program, AOCX files</td>
</tr>
<tr>
  <td class="path"><a href="./device/" style="padding-left: 2.0ex">device/</a></td>
  <td class="desc">OpenCL kernel files</td>
</tr>
<tr>
  <td class="path"><a href="./device/vector_add.cl" style="padding-left: 4.0ex">vector_add.cl</a></td>
  <td class="desc">Top-level OpenCL kernel file</td>
</tr>
<tr>
  <td class="path"><a href="./host/" style="padding-left: 2.0ex">host/</a></td>
  <td class="desc"></td>
</tr>
<tr>
  <td class="path"><a href="./host/src/" style="padding-left: 4.0ex">src/</a></td>
  <td class="desc">Host source files</td>
</tr>
</tbody>
</table>

</section>

<section>
<a id="Compiling_the_OpenCL_Kernel"><h2>Compiling the OpenCL Kernel</h2></a>
    <p>The top-level OpenCL kernel file is <span class="mono">device/vector_add.cl</span>.</p>
    <p>To compile the OpenCL kernel, run:</p>
    <div class="command">aoc device/vector_add.cl <span class="nowrap">-o</span> bin/vector_add.aocx --board <span class="highlight">&lt;<i>board</i>&gt;</span></div>
    <p>where <span class="highlight mono">&lt;<i>board</i>&gt;</span> matches the board you want to target.
    The <span class="mono">-o bin/vector_add.aocx</span> argument is used to place the compiled binary
    in the location that the host program expects.
    </p>
<p>If you are unsure of the boards available, use the following command to list
available boards:</p>
<div class="command">aoc --list-boards</div>
<section>
<h3>Compiling for Emulator</h3>
<p>To use the emulation flow, the compilation command just needs to be modified slightly:</p>
<div class="command">aoc <span class="highlight nowrap">-march=emulator</span> device/vector_add.cl -o bin/vector_add.aocx --board &lt;<i>board</i>&gt;</div>
</section>

</section>

<section>
<a id="Compiling_the_Host_Program"><h2>Compiling the Host Program</h2></a>
<p>To compile the host program, run:</p>
<div class="command">make</div>
<p>The compiled host program will be located at <span class="mono">bin/host</span>.</p>
<section>
<h3>Host Preprocessor Definitions</h3>
<p>The host program has the following preprocessor definitions:</p>
<table class="host-defines parameters">
<thead>
<tr>
  <th class="name">Define</th>
  <th class="type">Type</th>
  <th class="default">Default</th>
  <th class="desc">Description</th>
</tr>
</thead>
<tbody>
<tr>
  <td class="name">-D<span class="highlight">USE_SVM_API</span>=&lt;<i>#</i>&gt;</td>
  <td class="type">Optional</td>
  <td class="default">0</td>
  <td class="desc">
          This option when set to 1 will use the OpenCL 2.0 shared virtual memory (SVM) API.
        </td>
</tr>
</tbody>
</table>
<p>On Linux, custom values for preprocessor defines can be specified by setting 
the value of <mono>CPPFLAGS</mono> when invoking the Makefile.</p>

</section>

<section>
<a id="Running_the_Host_Program"><h2>Running the Host Program</h2></a>
<p>Before running the host program, you should have compiled the OpenCL kernel and the host program. Refer to the above sections if you have not completed those steps.</p>
<p>To run the host program on hardware, execute:</p>
<div class="command">bin/host</div>
<p>The output will include a wall-clock time of the OpenCL execution time
        and the kernel time as reported by the OpenCL event profiling API. The host
        program includes verification against the host CPU, printing out "PASS"
        when the results match.</p><section>
<h3>Running with the Emulator</h3>
<p>Prior to running the emulation flow, ensure that you have compiled the kernel for emulation. 
Refer to the above sections if you have not done so. Also, please set up your environment for
emulation. Please see the <a href="http://www.altera.com/literature/hb/opencl-sdk/aocl_programming_guide.pdf">Intel(R) FPGA SDK for OpenCL(TM) Programming Guide</a> for more information.</p>
<p>For this example design, the suggested emulation command is:</p>
<div class="command">CL_CONTEXT_EMULATOR_DEVICE_ALTERA=1 bin/host <span class="nowrap">-n=10000</span></div>
<section>
<h3>Host Parameters</h3>
<p>The general command-line for the host program is:</p>
<div class="command">bin/host <span class="nowrap">[-<span class="highlight">n</span>=&lt;<i>integer</i>&gt;]</span></div>
<p>where the one parameter is:</p>
<table class="host-params parameters">
<thead>
<tr>
  <th class="name">Parameter</th>
  <th class="type">Type</th>
  <th class="default">Default</th>
  <th class="desc">Description</th>
</tr>
</thead>
<tbody>
<tr>
  <td class="name">-<span class="highlight">n</span>=&lt;<i>integer</i>&gt;</td>
  <td class="type">Optional</td>
  <td class="default">100000</td>
  <td class="desc">Number of values to add.</td>
</tr>
</tbody>
</table>
</section>
<section>
<h3>OpenCL Binary Selection</h3>
<p>The host program requires a OpenCL binary (AOCX) file to run. For this example design, OpenCL binary files should be placed in the 
<span class="mono">bin</span> directory.</p>

<p>By default, the host program will look for a binary file in the following order (earlier pattern matches 
take priority):</p>
<ol>
  <li>A file named <span class="mono">vector_add.aocx</span>.</li>
  <li>A file named <span class="mono">vector_add_<span class="highlight">&lt;<i>board</i>&gt;</span>_170.aocx</span>, 
  where <span class="highlight mono">&lt;<i>board</i>&gt;</span> is the name of the board (as passed as the 
  <span class="mono">--board</span> argument to <span class="mono">aoc</span>).</li>
</ol>
</section>

</section>

<section>
<a id="Release_History"><h2>Release History</h2></a>
<p/>
<table class="history">
<thead>
<tr>
  <th class="version">Example Version</th>
  <th class="sdk-version">SDK Version</th>
  <th class="date">Date</th>
  <th class="changes">Changes</th>
</tr>
</thead>
<tbody>
<tr>
  <td class="version">1.5</td>
  <td class="sdk-version">16.0</td>
  <td class="date">November 2016</td>
  <td class="changes"><ul><li>Add SVM API option.</li></ul></td>
</tr>
<tr>
  <td class="version">1.4</td>
  <td class="sdk-version">16.0</td>
  <td class="date">June 2016</td>
  <td class="changes"><ul><li>Fixed makefile.</li></ul></td>
</tr>
<tr>
  <td class="version">1.3</td>
  <td class="sdk-version">14.1</td>
  <td class="date">December 2014</td>
  <td class="changes"><ul><li>New readme documentation.</li><li>Provide suggested emulation-specific arguments.</li></ul></td>
</tr>
<tr>
  <td class="version">1.2</td>
  <td class="sdk-version">14.0</td>
  <td class="date">July 2014</td>
  <td class="changes"><ul><li>Update documentation for 14.0 release.</li></ul></td>
</tr>
<tr>
  <td class="version">1.1</td>
  <td class="sdk-version">13.1</td>
  <td class="date">January 2014</td>
  <td class="changes"><ul><li>On Linux, fix possible compilation issues (missing include files).</li></ul></td>
</tr>
<tr>
  <td class="version">1.0</td>
  <td class="sdk-version">13.1</td>
  <td class="date">December 2013</td>
  <td class="changes"><ul><li>First release of example.</li></ul></td>
</tr>
</tbody>
</table>

</section>

<section>
<a id="Legal"><h2>Legal</h2></a>
<pre class="license">Copyright (C) 2013-2017 Altera Corporation, San Jose, California, USA. All rights reserved.
Permission is hereby granted, free of charge, to any person obtaining a copy of this
software and associated documentation files (the "Software"), to deal in the Software
without restriction, including without limitation the rights to use, copy, modify, merge,
publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to
whom the Software is furnished to do so, subject to the following conditions:
The above copyright notice and this permission notice shall be included in all copies or
substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
OTHER DEALINGS IN THE SOFTWARE.

This agreement shall be governed in all respects by the laws of the State of California and
by the laws of the United States of America.
</pre><section><h3>Trademarks</h3><div class="trademark"><p>OpenCL and the OpenCL logo are trademarks of Apple Inc. used by permission by Khronos.</p><p>Product is based on a published Khronos Specification, and has passed the Khronos Conformance Testing Process. Current conformance status can be found at <a href="www.khronos.org/conformance">www.khronos.org/conformance</a>.</p></div></section>
</section>

<section>
<a id="Contacting_Intel"><h2>Contacting Intel</h2></a>
<p>Although we have made every effort to ensure that this design example works
correctly, there might be problems that we have not encountered. If you have
a question or problem that is not answered by the information provided in 
this readme file or the example's documentation, please contact Intel
support (<a href="http://www.altera.com/myaltera">myAltera</a>).</p>

</section>

</body>
</html>
