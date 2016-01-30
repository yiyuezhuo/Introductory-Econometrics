# Introductory-Econometrics
The raw excel data is hard to use.In fact its header file is saved as structureless formal in .des file. 
Perherps you need to pick it columns manually. So I write a python script to autolink them(.xls file and .des file)
So you can analyse it easily.

## Function
* `load_data(file_name)`  link two file and return a nice pandas Dataframe object.

* `get_data(y_head,x_head,file_name,transform={})` pick the columns you want and drop NA value.the transform can apply log,square 
etc common transform.

* `regress(formula,file_name,summary=True)` regress data file by R-style formula.You can study it by statsmodels package document.

* `regress_h(y_head,X_head,file_name,summary=True)` Unfortunately,R-style formula sometime don't work.You can use it as reserve.

Note: `file_name` does not contain suffix because it represent two file that are similar name but not same suffix.

## Example

Example 8.4 by original book

You only need single line code.

  
    regress('price~lotsize+sqrft+bdrms','hprice1')
    
output are summary table and result object.

                                OLS Regression Results                            
    ==============================================================================
    Dep. Variable:                  price   R-squared:                       0.672
    Model:                            OLS   Adj. R-squared:                  0.661
    Method:                 Least Squares   F-statistic:                     57.46
    Date:                Sat, 30 Jan 2016   Prob (F-statistic):           2.70e-20
    Time:                        10:26:44   Log-Likelihood:                -482.88
    No. Observations:                  88   AIC:                             973.8
    Df Residuals:                      84   BIC:                             983.7
    Df Model:                           3                                         
    Covariance Type:            nonrobust                                         
    ==============================================================================
                     coef    std err          t      P>|t|      [95.0% Conf. Int.]
    ------------------------------------------------------------------------------
    Intercept    -21.7703     29.475     -0.739      0.462       -80.385    36.844
    lotsize        0.0021      0.001      3.220      0.002         0.001     0.003
    sqrft          0.1228      0.013      9.275      0.000         0.096     0.149
    bdrms         13.8525      9.010      1.537      0.128        -4.065    31.770
    ==============================================================================
    Omnibus:                       20.398   Durbin-Watson:                   2.110
    Prob(Omnibus):                  0.000   Jarque-Bera (JB):               32.278
    Skew:                           0.961   Prob(JB):                     9.79e-08
    Kurtosis:                       5.261   Cond. No.                     6.41e+04
    ==============================================================================
    
    Warnings:
    [1] Standard Errors assume that the covariance matrix of the errors is correctly specified.
    [2] The condition number is large, 6.41e+04. This might indicate that there are
    strong multicollinearity or other numerical problems.
    Out[2]: <statsmodels.regression.linear_model.RegressionResultsWrapper at 0x19ccdb70>
    
