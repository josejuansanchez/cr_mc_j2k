State of the art
================

#### Keywords
JPEG2000, Streaming, Conditional Replenishment, Motion Compensation


#### Conditional Replenishment of JPEG2000 tiles with Motion Compensation

**Notes** 

* Reduces the inter-frame redundancy present in common JPEG2000 sequences (MJP2 sequences).
* Applies a real-time motion compensation technique to the MJP2 sequences before transmission.
* They propose transmitting only the tiles that change in each JPEG2000 frame.
* *Review*: the method proposed for real-time tile change detection.

**References**  

1. [MIJ2K: Enhanced video transmission based on conditional replenishment of JPEG2000 tiles with motion compensation](http://www.sciencedirect.com/science/article/pii/S1047320311000253).  
Alvaro Luis Bustamante, José M. Molina López,  Miguel A. Patricio.  
Univ. Carlos III de Madrid, Madrid, Spain.  


#### Conditional Replenishment of JPEG2000 code-blocks with Motion Compensation

**Notes** 

* Too complex to be applied in real-time environments.
* Clients and servers have to be purposely designed for use with these techniques.


**References**  

1. [A novel paradigm for optimized scalable video transmission based on JPEG2000 with motion.](http://ieeexplore.ieee.org/stamp/stamp.jsp?tp=&arnumber=4379773)  
A. Naman, D. Taubman.  
IEEE International Conference on Image Processing, 2007. ICIP 2007, vol. 5, 2007.  


2. [Optimized scalable video transmission based on conditional replenishment of JPEG2000 code-blocks with motion compensation](http://delivery.acm.org/10.1145/1300000/1290061/p43-naman.pdf).  A. Naman, D. Taubman.  
Proceedings of the International Workshop on Mobile Video, ACM, New York, NY, USA (2007), pp. 43–48

3. [A flexible video transmission system based on JPEG 2000 conditional replenishment with multiple references](http://www.intopix.com/uploaded/Download%20Publications/intoPIX%20-%20A%20FLEXIBLE%20VIDEO%20TRANSMISSION%20SYSTEM%20BASED%20ON%20JPEG%202000%20CONDITIONAL%20REPLENISHMENTWITH%20MULTIPLE%20REFERENCES_FO_Devaux.pdf).  
F. Devaux, J. Meessen, C. Parisot, J. Delaigle, B. Macq, C. De Vleeschouwer.  
IEEE International Conference on Acoustics, Speech Signal Proces. (ICASSP 07).  


---

**Notes**

* They propose a rate-distortion optimal strategy to select the most profitable packets to transmit. 
* They provide the client with two references, the previous reconstructed frame and an estimation of the current scene background, which improves the transmission system performances.
 
**References**

* [A flexible video transmission system based on JPEG2000 Conditional Replenishment with multiple references](http://www.intopix.com/uploaded/Download%20Publications/intoPIX%20-%20A%20FLEXIBLE%20VIDEO%20TRANSMISSION%20SYSTEM%20BASED%20ON%20JPEG%202000%20CONDITIONAL%20REPLENISHMENTWITH%20MULTIPLE%20REFERENCES_FO_Devaux.pdf)

---

**Thesis**:

* [JPEG 2000 and Parity Bit Replenishment for Remote Video Browsing](http://www.intopix.com/uploaded/Download%20Publications/intoPIX_JPEG%202000%20and%20Parity%20Bit%20Replenishment%20for%20Remote%20Video%20Browsing_Thesis_FO_Devaux.pdf)  
  François-Olivier Devaux. September 2008.

* [JPEG2000-Based Scalable Interactive Video (JSIV)](http://www.hpca.ual.es/~jjsanchez/references/Thesis_JPEG2000-Based_Scalable_Interactive_Video.pdf)  
  Aous Thabit Naman. September 2010.

---

### Patents

* [Conditional replenishment for motion JPEG2000 &raquo;](http://www.google.com/patents/US8577157)  
  Inventors: [Fabrice Le Leannec](http://www.technicolor.com/en/talent/researcher/le-leannec) and [Xavier Henocq](http://www.informatik.uni-trier.de/~ley/pers/hd/h/Henocq:Xavier.html). / Canon.  
  Date of Patent: Nov. 5, 2013
  
---

* [Rate-constrained Conditional Replenishment Video Coding with Adaptive Change Detection](http://www.stanford.edu/class/ee368b/Projects/chiao/)  
  Xinqiao Liu. December 1, 2000.  

* [A New Video Compression Scheme Combining Conditional Replenishment and Address Event Representation](http://ieeexplore.ieee.org/xpls/abs_all.jsp?arnumber=4387612)  
  IEEE Workshop on Signal Processing Systems, 2007. Date of Conference: 17-19 Oct. 2007.

---

### References

* H. Everett, III. [Generalized lagrange multiplier method for solving problems of
optimum allocation of resources](http://www.hpca.ual.es/~jjsanchez/references/Generalized_Lagrange_multiplier_method_for_solving_problems_of_optimum_allocation_of_resources.pdf). Operations Research, 11(3):399–417, 1963