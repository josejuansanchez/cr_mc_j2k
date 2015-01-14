Knapsack Algorithm
==================

### Example

An image with **8 precincts** with **5 quality layers** at a specific resolution level.  
We know the size (in bytes) of each precinct.

```
weights (precincts sizes in bytes): 
      q0   q1    q2    q3    q4
      --   ---   ---   ---   ---
p0:   26   114   212   367   456 
p1:   72   195   296   333   491 
p2:   77   139   229   393   428 
p3:   10   140   218   361   431 
p4:   57   115   218   385   418 
p5:   70   176   228   328   411 
p6:   89   120   292   300   487 
p7:   47   173   247   342   472 
```

We know the profit that contribute each precinct in PSNR or SSIM values.

```
profit (psnr or ssim values): 
    q0    q1     q2     q3     q4
    ----  ----   -----  -----  -----
p0: 7.44  13.96  26.13  36.35  45.68 
p1: 9.01  17.77  22.35  35.04  43.49 
p2: 1.19  19.09  20.16  32.42  47.00 
p3: 5.97  11.84  29.77  39.39  48.80 
p4: 0.96  11.11  22.86  31.18  43.81 
p5: 7.78  13.47  20.06  39.14  40.62 
p6: 6.16  16.58  24.58  32.29  42.93 
p7: 0.25  11.30  20.70  32.60  46.34 
```

We know the order in which we have to send the precincts:

```
precincts_index_ordered_list: 
    3     6     2     5     0     1     4     7 
```

We know the maximum bitrate that the client can receive (in bytes).

```
max_bitrate: 370
```

Now, the problem is to obtain the best profit using the maximum bitrate allowed, considering that the order in which we have to send the precincts is given as a restriction.  
We can use the **Knapsack Algorithm** to find the best solution for this problem.  

```
          weight / profit             weight / profit             weight / profit             weight / profit             weight / profit
          -------------               ---------------             ---------------             ---------------             ---------------
w[3][0] = 10 / 5.969457  	w[3][1] = 140 / 11.841409  	w[3][2] = 218 / 29.769550  	w[3][3] = 361 / 39.391537  	w[3][4] = 431 / 48.800591  	
w[6][0] = 89 / 6.161998  	w[6][1] = 120 / 16.577244  	w[6][2] = 292 / 24.576733  	w[6][3] = 300 / 32.291481  	w[6][4] = 487 / 42.925354  	
w[2][0] = 77 / 1.193519  	w[2][1] = 139 / 19.087582  	w[2][2] = 229 / 20.161655  	w[2][3] = 393 / 32.422470  	w[2][4] = 428 / 47.000374  	
w[5][0] = 70 / 7.780912  	w[5][1] = 176 / 13.465715  	w[5][2] = 228 / 20.058510  	w[5][3] = 328 / 39.137154  	w[5][4] = 411 / 40.621147  	
w[0][0] = 26 / 7.440090  	w[0][1] = 114 / 13.955587  	w[0][2] = 212 / 26.129482  	w[0][3] = 367 / 36.348106  	w[0][4] = 456 / 45.677402  	
w[1][0] = 72 / 9.008389  	w[1][1] = 195 / 17.771700  	w[1][2] = 296 / 22.345627  	w[1][3] = 333 / 35.042130  	w[1][4] = 491 / 43.488808  	
w[4][0] = 57 / 0.955061  	w[4][1] = 115 / 11.114552  	w[4][2] = 218 / 22.859634  	w[4][3] = 385 / 31.177324  	w[4][4] = 418 / 43.811447  	
w[7][0] = 47 / 0.254135  	w[7][1] = 173 / 11.299870  	w[7][2] = 247 / 20.697052  	w[7][3] = 342 / 32.599762  	w[7][4] = 472 / 46.341999  
```

Possible solutions:

  1. 368 bytes / profit: 29.769550

    ```
    w[3][0] = 10 / 5.969457  	w[3][1] = 140 / 11.841409  	w[3][2] = 218 / 29.769550
    ```

  2. 359 bytes / profit: 28.418653

    ```
  	w[3][0] = 10 / 5.969457  	w[3][1] = 140 / 11.841409
  	w[6][0] = 89 / 6.161998  	w[6][1] = 120 / 16.577244
    ```

  3. 316 bytes / profit: 19,196926

  	```
  	w[3][0] = 10 / 5.969457  	w[3][1] = 140 / 11.841409
  	w[6][0] = 89 / 6.161998  	
  	w[2][0] = 77 / 1.193519
  	```

  4. 344 bytes / profit: 37,554365

  	```
  	w[3][0] = 10 / 5.969457
  	w[6][0] = 89 / 6.161998  	
  	w[2][0] = 77 / 1.193519
  	w[5][0] = 70 / 7.780912
  	w[0][0] = 26 / 7.440090
  	w[1][0] = 72 / 9.008389
  	```

For this example the solution 4 seems to be the best option.

*Note:* All the values used in this example are random values.

### References

* [Book: Knapsack Problems - Algorithms and Computer Implementations &raquo;](http://www.or.deis.unibo.it/knapsack.html) Silvano Martello.
* [Algorithms for Knapsack Problems &raquo;](http://www.diku.dk/~pisinger/95-1.pdf) Phd. Thesis, 1995. David Pisenger.
* [Lecture: The Knapsack Problem &raquo;](http://www.es.ele.tue.nl/education/5MC10/Solutions/knapsack.pdf)
* [A survey of effective heuristics and their application to a variety of knapsack problems &raquo;](http://pdf.aminer.org/000/226/090/the_quadratic_multiple_knapsack_problem_and_three_heuristic_approaches_to.pdf)
* [Knapsack Algorithm Implementations](http://rosettacode.org/wiki/Knapsack_problem/0-1)