//
//  ExerciseDetailsHelper.swift
//  KineTipsBaby
//
//  Created on 2026
//

import Foundation

extension BabyExerciseDataGenerator {
    
    static func generateDetailedInstructions(exerciseName: String, categoryId: String) -> String {
        // Age-appropriate detailed instructions
        if categoryId.contains("0_2") {
            return """
            1. Place baby on their back on a soft, comfortable surface
            2. Ensure baby is calm and alert, not hungry or tired
            3. Make eye contact and speak softly to baby
            4. Perform movements slowly and gently
            5. Watch for baby's cues - stop if they show discomfort
            6. Keep sessions short (2-3 minutes maximum)
            7. Support baby's head and neck at all times
            8. Celebrate with smiles and gentle praise
            """
        } else if categoryId.contains("2_4") {
            return """
            1. Position baby on a clean, padded surface
            2. Get down to baby's eye level for engagement
            3. Use colorful toys to motivate movement
            4. Demonstrate the movement first if possible
            5. Provide gentle support where needed
            6. Encourage with your voice and facial expressions
            7. Take breaks between repetitions
            8. End on a positive note with cuddles or play
            """
        } else if categoryId.contains("4_6") || categoryId.contains("6_8") {
            return """
            1. Clear the area of hazards and provide safe space
            2. Place engaging toys just out of reach to motivate
            3. Get on the floor with baby for encouragement
            4. Provide minimal support - let baby work
            5. Use enthusiastic praise for all attempts
            6. Allow rest periods as needed
            7. Keep sessions playful and fun
            8. Celebrate progress, no matter how small
            """
        } else if categoryId.contains("8_10") || categoryId.contains("10_12") {
            return """
            1. Baby-proof the area and remove obstacles
            2. Stay close for safety but allow independence
            3. Use toys and games to make it fun
            4. Demonstrate the activity if needed
            5. Encourage with clapping and cheering
            6. Let baby set the pace
            7. Provide support only when necessary
            8. Make it a positive, playful experience
            """
        } else {
            return """
            1. Create a safe, open space for movement
            2. Remove any hazards or obstacles
            3. Stay nearby for supervision and support
            4. Make the activity fun and game-like
            5. Use positive reinforcement and encouragement
            6. Allow child to explore at their own pace
            7. Take breaks when needed
            8. Celebrate all efforts and achievements
            """
        }
    }
    
    static func generateEnvironmentSetup(categoryId: String, themeSlug: String) -> String {
        var setup = "**Environment Setup:**\n\n"
        
        // Age-appropriate setup
        if categoryId.contains("0_2") {
            setup += """
            • Soft mat or blanket on the floor
            • Comfortable room temperature (68-72°F)
            • Quiet space with minimal distractions
            • Good lighting (natural light preferred)
            • Have a small towel for support if needed
            • Keep baby's favorite toy nearby
            • Ensure you have time without interruptions
            """
        } else if categoryId.contains("2_4") {
            setup += """
            • Large, clean play mat or soft surface
            • Remove small objects and choking hazards
            • Temperature-controlled comfortable room
            • Engaging toys within reach
            • Pillows or cushions for support
            • Mirror for visual engagement (optional)
            • Water bottle for parent nearby
            """
        } else if categoryId.contains("4_6") || categoryId.contains("6_8") {
            setup += """
            • Spacious, carpeted or padded area
            • Baby-proofed space (cover outlets, secure furniture)
            • Variety of safe toys at different distances
            • Low, stable furniture for pulling up
            • Cushions or pillows for safety
            • Remove sharp edges and corners
            • Keep phone nearby for photos/videos
            """
        } else if categoryId.contains("8_10") || categoryId.contains("10_12") {
            setup += """
            • Large open area free of obstacles
            • Stable furniture for cruising/support
            • Soft landing surfaces (mats, cushions)
            • Age-appropriate toys and balls
            • Secure all furniture to walls
            • Cover sharp corners and edges
            • Keep first aid kit accessible
            """
        } else {
            setup += """
            • Safe, spacious play area indoors or outdoors
            • Remove tripping hazards and obstacles
            • Soft surfaces for falls (grass, mats, carpet)
            • Age-appropriate equipment and toys
            • Proper footwear (or barefoot on safe surfaces)
            • Water and snacks nearby
            • Sunscreen if outdoors
            • Supervision at all times
            """
        }
        
        // Theme-specific additions
        if themeSlug.contains("tummy") {
            setup += "\n\n**Special Note:** Use a firm surface for tummy time, not a soft bed or couch."
        } else if themeSlug.contains("crawl") {
            setup += "\n\n**Special Note:** Ensure floor is clean and free of small objects baby could put in mouth."
        } else if themeSlug.contains("stand") || themeSlug.contains("walk") {
            setup += "\n\n**Special Note:** Clear area of furniture with sharp edges. Stay within arm's reach."
        } else if themeSlug.contains("climb") || themeSlug.contains("stairs") {
            setup += "\n\n**Special Note:** Always supervise climbing. Use safety gates when not practicing."
        }
        
        return setup
    }
}
