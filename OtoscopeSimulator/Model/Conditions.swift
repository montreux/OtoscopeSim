//
//  Conditions.swift
//  OtoscopeSimulator
//
//  Created by John Holcroft on 20/02/2016.
//  Copyright © 2016 John Holcroft. All rights reserved.
//

import Foundation

struct Conditions {
    static let Normal = Condition(name: "Normal", thumbnailName: "01_normal_thumb.jpg", imageName: "01_normal.jpg", testConditionName: ["Otitis Media", "Normal", "Perforated Eardrum", "Myringosclerosis"], informationText: "This is a normal tympanic membrane. Whilst it is important to recognise pathologies, it is equally important to recognise what is normal.")
    
    static let AcuteOtitisMedia = Condition(name: "Acute otitis media", thumbnailName: "02_otitismedia_thumb.jpg", imageName: "02_otitismedia.jpg", testConditionName: ["Otitis media with effusion", "Haemotympanum", "Glomus tumour", "Acute otitis media"], informationText: "Acute otitis media is an infection of the middle ear. Typically characterised by a bulging tympanic membrane.")
    
    static let Haemotympanum = Condition(name: "Haemotympanum", thumbnailName: "03_haemotympanum_thumb.jpg", imageName: "03_haemotympanum.jpg", testConditionName: ["Acute otitis media", "Otitis media with effusion", "Glomus tumour", "Haemotympanum"], informationText: "Haemotympanum can occur following trauma and can indicate a basal skull fracture. It is important to also check behind the ear lobe for bruising (Battle’s Sign).")
    
    static let TympanicMembranePerforation = Condition(name: "Tympanic Membrane Perforation", thumbnailName: "04_perforation_thumb.jpg", imageName: "04_perforation.jpg", testConditionName: ["Myringosclerosis", "Tympanic Membrane Perforation", "Haemotympanum", "Foreign Body"], informationText: "Tympanic membrane perforations can be caused by direct penetrating injury or from barotrauma - a sudden change in pressure.")
    
    static let Myringosclerosis = Condition(name: "Myringosclerosis", thumbnailName: "05_myringosclerosis_thumb.jpg", imageName: "05_myringosclerosis.jpg", testConditionName: ["Myringosclerosis", "Otitis Media", "Normal Tympanic Membrane", "Cholesteatoma"], informationText: "Myringosclerosis is scarring of the tympanic membrane. Commonly occurs secondary to recurrent infections of the middle ear.")
    
    static let OtitisMediaWithEffusion = Condition(name: "Otitis media with effusion", thumbnailName: "06_otitismedia_effusion_thumb.jpg", imageName: "06_otitismedia_effusion.jpg", testConditionName: ["Acute otitis media", "Haemotympanum", "Ottic barotrauma", "Otitis media with effusion"], informationText: "Otitis media with effusion is a very common condition in which the mucosal lining of the middle ear secretes fluid which may occur as a result of eustachian tube dysfunction. The condition is also known as ‘Glue Ear’.")
    
    static let ForeignBodyInsect = Condition(name: "Foreign body (insect)", thumbnailName: "07_insect_thumb.jpg", imageName: "07_insect.jpg", testConditionName: ["Myringosclerosis", "Foreign body (insect)", "Otitis media", "Normal Tympanic Membrane"], informationText: "Different types of foreign body require different methods of removal. Insects should be killed prior to their removal. This can be down by using mineral oil or lidocaine.")
    
    static let TestSet = [Normal, AcuteOtitisMedia, Haemotympanum, TympanicMembranePerforation, Myringosclerosis, OtitisMediaWithEffusion, ForeignBodyInsect]
}