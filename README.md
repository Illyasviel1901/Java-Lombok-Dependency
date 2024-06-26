# Java-Lombok-Dependency

<?xml version="1.0" encoding="UTF-8"?>
<project xmlns="http://maven.apache.org/POM/4.0.0"
         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/xsd/maven-4.0.0.xsd">
    <modelVersion>4.0.0</modelVersion>

    <groupId>org.example</groupId>
    <artifactId>Individual1</artifactId>
    <version>1.0-SNAPSHOT</version>

    <properties>
        <maven.compiler.source>19</maven.compiler.source>
        <maven.compiler.target>19</maven.compiler.target>
        <project.build.sourceEncoding>UTF-8</project.build.sourceEncoding>
    </properties>

    <dependencies>
        <dependency>
            <groupId>org.projectlombok</groupId>
            <artifactId>lombok</artifactId>
            <version>1.18.20</version>
            <scope>provided</scope>
        </dependency>

        <dependency>
            <groupId>org.apache.poi</groupId>
            <artifactId>poi</artifactId>
            <version>5.2.5</version>
        </dependency>

        <dependency>
            <groupId>org.apache.poi</groupId>
            <artifactId>poi-ooxml</artifactId>
            <version>5.2.5</version>
        </dependency>

        <dependency>
            <groupId>com.formdev</groupId>
            <artifactId>flatlaf</artifactId>
            <version>3.4</version>
        </dependency>


        <dependency>
            <groupId>org.swinglabs</groupId>
            <artifactId>swingx</artifactId>
            <version>1.6.1</version>
        </dependency>

        <dependency>
            <groupId>com.mysql</groupId>
            <artifactId>mysql-connector-j</artifactId>
            <version>8.2.0</version>
        </dependency>


    </dependencies>

    <build>
        <plugins>

            <plugin>
                <groupId>org.apache.maven.plugins</groupId>
                <artifactId>maven-compiler-plugin</artifactId>
                <version>3.11.0</version>
                <configuration>
                    <source>17</source>
                    <target>17</target>
                    <annotationProcessorPaths>
                        <path>
                            <groupId>org.projectlombok</groupId>
                            <artifactId>lombok</artifactId>
                            <version>1.18.20</version>
                        </path>
                    </annotationProcessorPaths>
                </configuration>
            </plugin>

        </plugins>
    </build>

</project>

--------------------------------------------------------------------------------------------------------
public void refreshIngredientTable(DefaultTableModel tableModel, JTable table, String query){
        try (Connection conn = ConnectionManager.createConnection()) {
            try(ResultSet resultSet = conn.createStatement().executeQuery(query)){
                ingredientMap.clear();

                //empty the model
                tableModel.setColumnCount(0);
                tableModel.setRowCount(0);

                //GET COLUMN NAMES
                ResultSetMetaData metaData = resultSet.getMetaData();
                int columnCount = metaData.getColumnCount();
                for (int i = 2; i <= columnCount; i++) {
                    String columnName = metaData.getColumnName(i).toUpperCase();
                    tableModel.addColumn(columnName);
                }
                int idx = 0;
                // ADD ROWS TO TABLE
                while (resultSet.next()) {

                    Object[] rowData = new Object[columnCount - 1];
                    for (int i = 2; i <= columnCount; i++) {
                        if (i == 2) {
                            String row = resultSet.getString(i);
                            ingredientMap.put(row, resultSet.getInt(1));
//                            rowIndexIngredientMap.put(idx, row);
                            idx++;
                        }
                        rowData[i - 2] = resultSet.getObject(i);
                    }
                    tableModel.addRow(rowData);
                }

                // CENTER VALUES
                DefaultTableCellRenderer centerRenderer = new DefaultTableCellRenderer();
                centerRenderer.setHorizontalAlignment(SwingConstants.CENTER);
                for (int i = 0; i < tableModel.getColumnCount(); i++) {
                    table.getColumnModel().getColumn(i).setCellRenderer(centerRenderer);
                }

                // MAKE COLUMN NAMES BOLD
                JTableHeader header = table.getTableHeader();
                header.setFont(new Font("Arial", Font.BOLD, 12));
            }

        } catch (SQLException e) {
            System.out.println(e.getMessage());
        }
    }


--------------------------------------------------------------------------------------------------------




SET @db_exists = (SELECT COUNT(*) FROM information_schema.schemata WHERE schema_name = 'cakeShop');

SET @sql = CASE WHEN @db_exists > 0 THEN 'DROP DATABASE IF EXISTS cakeShop;' ELSE '' END;

PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

DROP DATABASE IF EXISTS shop;
CREATE DATABASE IF NOT EXISTS shop;
use shop;

CREATE TABLE product (
	id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) UNIQUE NOT NULL,
    price DOUBLE NOT NULL,
    expiration_date DATE
);

CREATE TABLE client (
	id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) UNIQUE NOT NULL,
    birthdate DATE
);

CREATE TABLE client_product (
	client_id INT,
    product_id INT,
    PRIMARY KEY (client_id, product_id),
    FOREIGN KEY (client_id) REFERENCES client(id) ON DELETE CASCADE,
    FOREIGN KEY (product_id) REFERENCES product(id) ON DELETE CASCADE
);

INSERT INTO product (name, price, expiration_date) VALUES
('Jucarie', 150, '9999-12-31'),
('Ketchup', 20, '2024-12-12'),
('Apa', 10, '2024-10-13'),
('Bere', 30, '2025-01-17');

INSERT INTO client (name, birthdate) VALUES
('Ion Popescu', '1984-08-10'),
('Sirghi Catalin', '2004-10-01');

INSERT INTO client_product (client_id, product_id) VALUES
(1, 1), (1, 3), (2, 2), (2, 4);

SELECT product.name FROM product 
JOIN client_product ON product.id = client_product.product_id
JOIN client ON client.id = client_product.client_id
WHERE client.name = 'Sirghi Catalin'
