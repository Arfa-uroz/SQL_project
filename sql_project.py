import matplotlib as mpl
import matplotlib.pyplot as plt
import numpy as np
import matplotlib.patches as mpatches

table_names = ['Customers', 'Products', 'ProductLines', 'Orders', 'OrderDetails', 'Payments', 'Employees', 'Offices']
number_of_attributes = [13, 9, 4, 7, 5, 4, 8, 9]
number_of_rows = [122, 110, 7, 326, 2996, 273, 23, 7]

barWidth = 0.25

'''
#Two bars along each table name.
br1 = np.arange(len(number_of_attributes))
br2 = [x + barWidth for x in br1]

plt.bar(br1, number_of_attributes, color='r', width=barWidth,
        edgecolor='grey', label='number_of_attributes')
plt.bar(br2, number_of_rows, color='g', width=barWidth,
        edgecolor='grey', label='number_of_rows')
plt.xticks([r + barWidth for r in range(len(number_of_attributes))],
		['Customers', 'Products', 'ProductLines', 'Orders', 'OrderDetails', 'Payments', 'Employees', 'Offices'])'''

#Bar graph showing the number of attributes(or number of coloumns) belonging to each table.
fig = plt.figure(figsize=(10, 5))
plt.bar(table_names, number_of_attributes, color='maroon',
        width=0.4)
plt.xlabel("table_names")
plt.ylabel("number_of_attributes")
plt.title("Tables Data")
plt.legend()
plt.show()

#Bar graph showing the number of rows belonging to each table.
fig = plt.figure(figsize=(10, 5))
plt.bar(table_names, number_of_rows, color='green',
        width=0.6)
plt.xlabel("table_names")
plt.ylabel("number_of_rows")
plt.title("Tables Data")
plt.show()

#Pie chart showing the performance of of top 10 products which are already low in stock.
pro_code = ['S12_2823', 'S18_3482', 'S18_1984', 'S18_2325', 'S18_1589', 'S18_2870', 'S12_3380', 'S700_2466', 'S24_3432', 'S32_2206']
pro_performance = [135767.03, 121890.6, 119050.95, 109992.01, 101778.13, 100770.12, 98718.76, 89347.8, 87404.81, 33268.76]
fig = plt.figure(figsize=(10, 7))
plt.pie(pro_performance, labels=pro_code)
plt.title("Product's Performance representation which are low on stock")
plt.show()


#Horizontal Bar graph representing the top 5 VIP customers and 5 of the least engaged customers.
customer_names = ['Euro+ Shopping Channel', 'Mini Gifts Distributors Ltd.', 'Muscle Machine Inc', 'Australian Collectors, Co.', 'La Rochelle Gifts', 'Boards & Toys Co.', 'Auto-Moto Classics Inc.', 'Frau da Collezione', 'Atelier graphique', 'Double Decker Gift Stores, Ltd']
profits = [326519.66, 236769.39, 72370.09, 70311.07, 60875.3, 2610.87, 6586.02, 9532.93, 10063.8, 10868.04]
fig, ax = plt.subplots(figsize =(15, 10))
ax.barh(customer_names, profits, color=['pink', 'pink', 'pink', 'pink', 'pink', 'blue', 'blue', 'blue', 'blue', 'blue'])

plt.xlabel("Profits", fontsize=15, fontweight='bold')
plt.ylabel("Customer Names", fontsize=20, fontweight='bold')
plt.title("Customer Distribution", fontsize=20, fontweight='bold')
pink_patch = mpatches.Patch(color='pink', label='VIP customers')
blue_patch = mpatches.Patch(color='blue', label='Least Engaged Users')
ax.legend(handles=[pink_patch, blue_patch], fontsize=20)
#plt.legend(handles=['VIP customers', 'Least Engaged Users'], fontsize=)
plt.show()