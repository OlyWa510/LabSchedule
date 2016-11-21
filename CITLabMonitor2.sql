-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL,ALLOW_INVALID_DATES';

-- -----------------------------------------------------
-- Schema CITLabMonitor
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema CITLabMonitor
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `CITLabMonitor` DEFAULT CHARACTER SET utf8 ;
USE `CITLabMonitor` ;

-- -----------------------------------------------------
-- Table `CITLabMonitor`.`Major`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `CITLabMonitor`.`Major` (
  `MajorId` INT NOT NULL AUTO_INCREMENT,
  `MajorName` VARCHAR(50) NOT NULL,
  PRIMARY KEY (`MajorId`),
  UNIQUE INDEX `MajorName_UNIQUE` (`MajorName` ASC))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `CITLabMonitor`.`AppUser`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `CITLabMonitor`.`AppUser` (
  `UserID` INT NOT NULL AUTO_INCREMENT,
  `FirstName` VARCHAR(45) NULL,
  `LastName` VARCHAR(45) NULL,
  `L#` VARCHAR(9) NULL,
  `Password` VARCHAR(16) NULL,
  `Email Address` VARCHAR(50) NULL,
  PRIMARY KEY (`UserID`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `CITLabMonitor`.`Student`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `CITLabMonitor`.`Student` (
  `StudentID` INT NOT NULL,
  `MajorId` INT NOT NULL,
  `AppUser_UserID` INT NOT NULL,
  PRIMARY KEY (`StudentID`),
  INDEX `Student_Major_FK_idx` (`MajorId` ASC),
  UNIQUE INDEX `UserID_UNIQUE` (`StudentID` ASC),
  INDEX `fk_Student_AppUser1_idx` (`AppUser_UserID` ASC),
  CONSTRAINT `Student_Major_FK`
    FOREIGN KEY (`MajorId`)
    REFERENCES `CITLabMonitor`.`Major` (`MajorId`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Student_AppUser1`
    FOREIGN KEY (`AppUser_UserID`)
    REFERENCES `CITLabMonitor`.`AppUser` (`UserID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `CITLabMonitor`.`Instructor`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `CITLabMonitor`.`Instructor` (
  `InstructorID` INT NOT NULL,
  `AppUser_UserID` INT NOT NULL,
  PRIMARY KEY (`InstructorID`),
  INDEX `fk_Instructor_AppUser1_idx` (`AppUser_UserID` ASC),
  CONSTRAINT `fk_Instructor_AppUser1`
    FOREIGN KEY (`AppUser_UserID`)
    REFERENCES `CITLabMonitor`.`AppUser` (`UserID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `CITLabMonitor`.`Course`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `CITLabMonitor`.`Course` (
  `CourseNumber` VARCHAR(10) NOT NULL,
  `CourseName` VARCHAR(50) NOT NULL,
  `LeadInstructorId` INT NOT NULL,
  PRIMARY KEY (`CourseNumber`),
  UNIQUE INDEX `CourseName_UNIQUE` (`CourseName` ASC),
  INDEX `Course_Instructor_FK_idx` (`LeadInstructorId` ASC),
  CONSTRAINT `Course_Instructor_FK`
    FOREIGN KEY (`LeadInstructorId`)
    REFERENCES `CITLabMonitor`.`Instructor` (`InstructorID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `CITLabMonitor`.`Term`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `CITLabMonitor`.`Term` (
  `TermId` INT NOT NULL,
  `TermName` VARCHAR(50) NOT NULL,
  PRIMARY KEY (`TermId`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `CITLabMonitor`.`Section`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `CITLabMonitor`.`Section` (
  `SectionNumber` VARCHAR(5) NOT NULL,
  `TermID` INT NOT NULL,
  `Year` INT NOT NULL,
  `InstructorID` INT NOT NULL,
  `CourseNumber` VARCHAR(10) NOT NULL,
  PRIMARY KEY (`SectionNumber`, `TermID`, `Year`),
  INDEX `Section_Term_FK_idx` (`TermID` ASC),
  INDEX `Section_Instructor_FK_idx` (`InstructorID` ASC),
  INDEX `Section_Course_FK_idx` (`CourseNumber` ASC),
  CONSTRAINT `Section_Term_FK`
    FOREIGN KEY (`TermID`)
    REFERENCES `CITLabMonitor`.`Term` (`TermId`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `Section_Instructor_FK`
    FOREIGN KEY (`InstructorID`)
    REFERENCES `CITLabMonitor`.`Instructor` (`InstructorID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `Section_Course_FK`
    FOREIGN KEY (`CourseNumber`)
    REFERENCES `CITLabMonitor`.`Course` (`CourseNumber`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `CITLabMonitor`.`StudentRegistration`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `CITLabMonitor`.`StudentRegistration` (
  `StudentId` INT NOT NULL,
  `SectionNumber` VARCHAR(5) NOT NULL,
  `TermId` INT NOT NULL,
  `Year` INT NOT NULL,
  PRIMARY KEY (`StudentId`, `SectionNumber`, `TermId`, `Year`),
  INDEX `StudentRegistration_Section_FK_idx` (`SectionNumber` ASC, `TermId` ASC, `Year` ASC),
  CONSTRAINT `StudentRegistration_Student_FK`
    FOREIGN KEY (`StudentId`)
    REFERENCES `CITLabMonitor`.`Student` (`StudentID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `StudentRegistration_Section_FK`
    FOREIGN KEY (`SectionNumber` , `TermId` , `Year`)
    REFERENCES `CITLabMonitor`.`Section` (`SectionNumber` , `TermID` , `Year`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `CITLabMonitor`.`Location`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `CITLabMonitor`.`Location` (
  `LocationId` INT NOT NULL AUTO_INCREMENT,
  `LocationName` VARCHAR(50) NOT NULL,
  `StationId` INT NULL,
  PRIMARY KEY (`LocationId`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `CITLabMonitor`.`Visit`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `CITLabMonitor`.`Visit` (
  `VisitId` INT NOT NULL AUTO_INCREMENT,
  `StartTime` DATETIME NOT NULL,
  `EndTime` DATETIME NULL,
  `StudentId` INT NOT NULL,
  `LocationId` INT NOT NULL,
  PRIMARY KEY (`VisitId`),
  INDEX `Visit_Student_FK_idx` (`StudentId` ASC),
  INDEX `Visit_Location_FK_idx` (`LocationId` ASC),
  CONSTRAINT `Visit_Student_FK`
    FOREIGN KEY (`StudentId`)
    REFERENCES `CITLabMonitor`.`Student` (`StudentID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `Visit_Location_FK`
    FOREIGN KEY (`LocationId`)
    REFERENCES `CITLabMonitor`.`Location` (`LocationId`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `CITLabMonitor`.`Task`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `CITLabMonitor`.`Task` (
  `TaskId` INT NOT NULL AUTO_INCREMENT,
  `VisitId` INT NOT NULL,
  `SectionNumber` VARCHAR(5) NULL,
  `BriefDescription` VARCHAR(50) NOT NULL,
  `StartTime` DATETIME NOT NULL,
  `EndTime` DATETIME NULL,
  PRIMARY KEY (`TaskId`),
  INDEX `Task_Visit_FK_idx` (`VisitId` ASC),
  INDEX `Task_Section_FK_idx` (`SectionNumber` ASC),
  CONSTRAINT `Task_Visit_FK`
    FOREIGN KEY (`VisitId`)
    REFERENCES `CITLabMonitor`.`Visit` (`VisitId`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `Task_Section_FK`
    FOREIGN KEY (`SectionNumber`)
    REFERENCES `CITLabMonitor`.`Section` (`SectionNumber`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `CITLabMonitor`.`Tutor`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `CITLabMonitor`.`Tutor` (
  `TutorID` VARCHAR(45) NOT NULL,
  `AppUser_UserID` INT NOT NULL,
  INDEX `fk_Tutor_AppUser1_idx` (`AppUser_UserID` ASC),
  PRIMARY KEY (`TutorID`),
  CONSTRAINT `fk_Tutor_AppUser1`
    FOREIGN KEY (`AppUser_UserID`)
    REFERENCES `CITLabMonitor`.`AppUser` (`UserID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `CITLabMonitor`.`TutorExpertise`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `CITLabMonitor`.`TutorExpertise` (
  `TutorExpertiseID` INT NOT NULL AUTO_INCREMENT,
  `Course_CourseNumber` VARCHAR(10) NOT NULL,
  `Tutor_TutorID` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`TutorExpertiseID`),
  INDEX `fk_TutorExpertise_Course1_idx` (`Course_CourseNumber` ASC),
  INDEX `fk_TutorExpertise_Tutor1_idx` (`Tutor_TutorID` ASC),
  CONSTRAINT `fk_TutorExpertise_Course1`
    FOREIGN KEY (`Course_CourseNumber`)
    REFERENCES `CITLabMonitor`.`Course` (`CourseNumber`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_TutorExpertise_Tutor1`
    FOREIGN KEY (`Tutor_TutorID`)
    REFERENCES `CITLabMonitor`.`Tutor` (`TutorID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `CITLabMonitor`.`Schedule`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `CITLabMonitor`.`Schedule` (
  `Tutor_TutorID` VARCHAR(45) NOT NULL,
  `StartTime` datetime NULL,
  `EndTime` datetime NULL,
  `WeekDay` INT NULL,
  INDEX `fk_Schedule_Tutor1_idx` (`Tutor_TutorID` ASC),
  PRIMARY KEY (`Tutor_TutorID`),
  CONSTRAINT `fk_Schedule_Tutor1`
    FOREIGN KEY (`Tutor_TutorID`)
    REFERENCES `CITLabMonitor`.`Tutor` (`TutorID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `CITLabMonitor`.`Question`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `CITLabMonitor`.`Question` (
  `QuestionID` INT NOT NULL,
  `Student_StudentID` INT NOT NULL,
  `Description` VARCHAR(300) NULL,
  `Status` VARCHAR(20) NULL,
  `StartTime` datetime NULL,
  `OpenTime` datetime NULL,
  `CloseTime` datetime NULL,
  PRIMARY KEY (`QuestionID`),
  INDEX `fk_Question_Student1_idx` (`Student_StudentID` ASC),
  CONSTRAINT `fk_Question_Student1`
    FOREIGN KEY (`Student_StudentID`)
    REFERENCES `CITLabMonitor`.`Student` (`StudentID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
