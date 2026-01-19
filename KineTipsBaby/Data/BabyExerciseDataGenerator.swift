//
//  BabyExerciseDataGenerator.swift
//  KineTipsBaby
//
//  Created on 2026
//

import Foundation

class BabyExerciseDataGenerator {
    
    static func generateThemeExercises(programId: String) -> BabyProgram? {
        var categoryId = programId
        var themeSlug = ""
        
        if let range = programId.range(of: "_th_") {
            categoryId = String(programId[..<range.lowerBound])
            themeSlug = String(programId[range.upperBound...])
        }
        
        let ageRange = ageRangeForCategory(categoryId: categoryId)
        let themeTitle = themeTitleForSlug(categoryId: categoryId, themeSlug: themeSlug)
        let themeHint = themeHintForSlug(categoryId: categoryId, themeSlug: themeSlug)
        let names = exerciseNamesForTheme(categoryId: categoryId, themeSlug: themeSlug, themeTitle: themeTitle)
        let steps = exerciseStepsForTheme(categoryId: categoryId, themeSlug: themeSlug)
        
        var exercises: [BabyExercise] = []
        for i in 0..<10 {
            let name = names[i]
            let step = steps[i]
            let desc = "\(step)"
            
            let timed = (i % 2 == 0)
            let duration = timed ? 60 : 0
            let reps = timed ? 0 : 10
            
            // Generate detailed instructions
            let detailedInstructions = generateDetailedInstructions(exerciseName: name, categoryId: categoryId)
            let environmentSetup = generateEnvironmentSetup(categoryId: categoryId, themeSlug: themeSlug)
            let parentTips = themeHint
            
            let exercise = BabyExercise(
                exerciseName: name,
                exerciseDescription: desc,
                detailedInstructions: detailedInstructions,
                environmentSetup: environmentSetup,
                parentTips: parentTips,
                thumbnailName: "baby_logo",
                videoURL: nil,
                durationSeconds: duration,
                repetitions: reps,
                ageRangeMonthsMin: ageRange.0,
                ageRangeMonthsMax: ageRange.1
            )
            exercises.append(exercise)
        }
        
        return BabyProgram(
            programId: programId,
            categoryId: categoryId,
            themeSlug: themeSlug,
            themeTitle: themeTitle,
            themeHint: themeHint,
            exercises: exercises,
            ageRangeMin: ageRange.0,
            ageRangeMax: ageRange.1
        )
    }
    
    static func ageRangeForCategory(categoryId: String) -> (Int, Int) {
        switch categoryId {
        case "p_0_2": return (0, 2)
        case "p_2_4": return (2, 4)
        case "p_4_6": return (4, 6)
        case "p_6_8": return (6, 8)
        case "p_8_10": return (8, 10)
        case "p_10_12": return (10, 12)
        case "p_12_18": return (12, 18)
        default: return (0, 18)
        }
    }
    
    static func exerciseNamesForTheme(categoryId: String, themeSlug: String, themeTitle: String) -> [String] {
        if categoryId == "p_0_2" {
            switch themeSlug {
            case "calm_connect":
                return ["Gentle Hold", "Skin-to-Skin", "Slow Rock", "Eye Contact", "Soft Voice", "Calm Breathing", "Still Pause", "Gentle Sway", "Quiet Time", "End Hold"]
            case "track_soothe":
                return ["Face Tracking", "Slow Toy Move", "Side-to-Side", "Up & Down", "Pause & Reset", "Soft Rattle", "Gentle Voice", "Eye Follow", "Short Track", "Calm Finish"]
            case "stretch":
                return ["Leg Stretch", "Arm Stretch", "Hip Circles", "Ankle Flex", "Shoulder Relax", "Neck Support", "Gentle Twist", "Knee to Chest", "Arm Circles", "Calm Finish"]
            case "arm_mobility":
                return ["Shoulder Support Hold", "Arm Open & Close", "Hands to Midline", "Gentle Arm Circles", "Cross-Body Reach", "Elbow Bend & Extend", "Palm Open Relax", "Hand-to-Cheek Touch", "Slow Symmetry Check", "Calm Finish"]
            case "side_lying":
                return ["Supported Side-lying Setup", "Towel Roll Support", "Hands to Midline", "Toy in Front", "Short Side Switch", "Head Support Check", "Hip Comfort Check", "Gentle Reach Cue", "Calm Pause", "End Hold"]
            case "massage":
                return ["Leg Massage", "Arm Massage", "Foot Rub", "Hand Massage", "Belly Clockwise", "Back Soothing", "Shoulder Relax Touch", "Cheek/Face Touch", "Slow Pressure Test", "Stop Cue Practice"]
            case "feeding_posture":
                return ["Chin Off Chest Check", "Midline Alignment", "Switch Sides", "Supported Burp Hold", "Shoulder Relax", "Hip Comfort", "Neck Neutral", "Slow Reposition", "Short Break", "Calm Finish"]
            case "sensory_calm":
                return ["Soft Voice Cue", "Gentle Touch", "Slow Rock", "Quiet Music", "Dim Light", "White Noise", "One Sensory Item", "Stop if Overstimulated", "Short Calm Pause", "End Still"]
            default:
                return Array(repeating: themeTitle, count: 10)
            }
        }
        
        if categoryId == "p_2_4" {
            switch themeSlug {
            case "tummy":
                return ["Tummy on Chest", "Tummy on Mat", "Towel Roll Support", "Toy Motivation", "Head Turn Practice", "Short Set Reset", "Reach on Tummy", "Elbows Under Shoulders", "Tiny Push-Up", "Calm Finish"]
            case "head_control":
                return ["Supported Upright Carry", "Tummy Head Lift", "Side Look Practice", "Midline Look", "Slow Turn Right", "Slow Turn Left", "Short Break Reset", "Chest Support", "Neck Neutral Check", "End Hold"]
            case "reach_track":
                return ["Toy Within Reach", "Slow Track Right", "Slow Track Left", "Hands to Toy", "One-Hand Reach", "Two-Hand Hold", "Bring Toy to Mouth", "Open Palm Practice", "Gentle Pull (No Force)", "Reach Across Body"]
            case "sensory_play":
                return ["Texture Touch", "Soft Rattle Listen", "Toy Tap", "Gentle Mirror Look", "One Item Only", "Pause & Reset", "Switch Texture", "Short Calm Break", "Stop if Overstimulated", "End Still"]
            case "calm_reset":
                return ["Slow Rock", "Cradle Sway", "Quiet Voice", "Dim Lights", "Breathing Sync", "Short Hold", "Side-to-Side", "Stillness Pause", "Stop Cue", "End Hold"]
            case "gentle_mobility":
                return ["Comfort Stretch", "Hands to Midline", "Short Tummy Set", "Toy Reach", "Side-lying Switch", "Leg Bicycles", "Arm Mobility", "Slow Reset", "Pause Often", "Calm Finish"]
            default:
                return Array(repeating: themeTitle, count: 10)
            }
        }
        
        if categoryId == "p_4_6" {
            switch themeSlug {
            case "tummy_reach":
                return ["Tummy Setup", "Elbows Under Shoulders", "Toy Just in Front", "Reach Right", "Reach Left", "Tiny Push-Up", "Weight Shift Right", "Weight Shift Left", "Rest & Reset", "Calm Finish"]
            case "roll_to_tummy":
                return ["Toy to Side", "Assist Shoulder", "Assist Hip", "Pause on Side", "Finish Roll", "Tummy Reset", "Try Other Side", "Minimal Help", "Celebrate", "Calm Finish"]
            case "roll_to_back":
                return ["Tummy Start", "Toy Up & Over", "Shift the Hips", "Pause on Side", "Back Landing", "Hands to Midline", "Try Other Side", "Slow Pattern", "Rest Break", "Calm Finish"]
            case "side_lying":
                return ["Side-lying Setup", "Towel Support", "Hands to Midline", "Toy in Front", "Short Reach", "Switch Sides", "Rolling Hint", "Head Turn", "Pause", "Finish"]
            case "sit_support":
                return ["Supported Sit Setup", "Hips Back", "Trunk Support", "Hands Forward", "Short Hold", "Reset Often", "Toy at Midline", "No Pushing Through Fatigue", "Celebrate", "End Calm"]
            case "sit_balance":
                return ["Supported Sit", "Tiny Reach Right", "Tiny Reach Left", "Toy to Side", "Short Hold", "Reset", "Hands Catch", "Celebrate", "Rest", "Finish"]
            case "hands_grasp":
                return ["Toy Offer", "Grasp Practice", "Hold & Release", "Transfer Hand-to-Hand", "Bring to Mouth", "Two-Hand Hold", "Open Palm Practice", "Gentle Pull (No Force)", "Reach Across Body", "Short Pause"]
            case "feet_play":
                return ["Hands to Feet", "Toe Wiggle", "Foot Hold", "Gentle Leg Lift", "Knee to Chest", "Hip Comfort", "Ankle Flex", "Short Play", "Rest", "Calm Finish"]
            case "pivot_play":
                return ["Tummy Setup", "Toy to Right", "Tiny Pivot", "Toy to Left", "Pivot Other Way", "Elbows Under Shoulders", "Short Rest", "Repeat", "Celebrate", "End Calm"]
            case "back_play":
                return ["Back Setup", "Toy Above", "Slow Track", "Hands to Midline", "Reach Up", "Two-Hand Hold", "Bring to Mouth", "Short Rest", "Repeat", "Calm Finish"]
            default:
                return Array(repeating: themeTitle, count: 10)
            }
        }
        
        if categoryId == "p_6_8" {
            switch themeSlug {
            case "sit_balance":
                return ["Independent Sit", "Tiny Reach Right", "Tiny Reach Left", "Toy to Side", "Hands Catch", "Short Hold", "Reset", "Repeat", "Celebrate", "Finish"]
            case "sit_to_floor":
                return ["Sit & Pause", "Hands Forward", "Slow Lean", "Controlled Lower", "Tummy Landing", "Toy in Front", "Back to Sit (Assist)", "Break", "Repeat", "End Calm"]
            case "floor_to_sit":
                return ["Tummy Setup", "Side-lying Roll", "Prop on Elbow", "Hand on Floor", "Hip Assist", "Arrive Sitting", "Toy at Midline", "Short Hold", "Break", "Finish"]
            case "all_fours_rock":
                return ["Hands-and-Knees Setup", "Rock Forward", "Rock Back", "Pause", "Rock Side-to-Side", "Short Break", "Repeat Rock", "Toy Motivation", "End with Tummy", "Calm Finish"]
            case "hands_knees_setup":
                return ["Tummy Start", "Bring Knees Under Hips", "Hands Under Shoulders", "Hold 3 Seconds", "Release to Tummy", "Repeat", "Toy in Front", "Short Hold", "Break", "Finish Calm"]
            case "belly_crawl":
                return ["Tummy Setup", "Toy in Front", "Belly Drag", "Use Arms", "Use Legs", "Any Forward Movement", "Celebrate", "Short Rest", "Repeat", "End Play"]
            case "reach_pivot":
                return ["Tummy Setup", "Toy to Right", "Reach & Pivot", "Toy to Left", "Pivot Other Way", "Belly Crawl Try", "Short Rest", "Repeat", "Celebrate", "Finish"]
            case "kneel_play":
                return ["Tall Kneel Setup", "Support at Surface", "Short Hold", "Toy at Eye Level", "Reach Up", "Balance Check", "Hip Support", "Short Duration", "Rest", "Finish"]
            case "hand_coordination":
                return ["Container Play", "Drop-In", "Take-Out", "Transfer Toy", "Two-Hand Hold", "Open/Close Lid", "Stack Attempt", "Short Break", "Repeat", "End Play"]
            case "cause_effect_play":
                return ["Press a Button Toy", "Pull a Cloth", "Drop-in Play", "Find the Toy", "Open/Close Container", "Push a Ball", "Repeat", "Short Break", "One More Try", "Calm Finish"]
            default:
                return Array(repeating: themeTitle, count: 10)
            }
        }
        
        if categoryId == "p_8_10" {
            switch themeSlug {
            case "crawl_explore":
                return ["Crawl Forward", "Crawl to Toy", "Crawl Around Object", "Crawl Over Pillow", "Crawl Under Table", "Speed Crawl", "Direction Change", "Crawl & Stop", "Crawl & Sit", "Finish Play"]
            case "pull_to_stand":
                return ["Kneel at Couch", "Pull Up to Stand", "Hold Standing", "Knee Bend Down", "Pull Up Again", "Side Step Hold", "Let Go Briefly", "Controlled Lower", "Repeat", "End Stand"]
            case "cruise_furniture":
                return ["Stand at Couch", "Side Step Right", "Side Step Left", "Reach for Toy", "Two Steps Right", "Two Steps Left", "Turn Corner", "Short Rest", "Repeat", "Finish"]
            case "squat_play":
                return ["Stand at Surface", "Squat Down", "Pick Up Toy", "Stand Back Up", "Squat Again", "Place Toy Down", "Stand Up", "Repeat Pattern", "Rest", "End Play"]
            case "transition_practice":
                return ["Sit to Stand", "Stand to Sit", "Sit to Crawl", "Crawl to Sit", "Sit to Kneel", "Kneel to Stand", "Stand to Squat", "Squat to Stand", "Rest", "Finish"]
            case "hand_skills":
                return ["Pincer Grasp", "Pick Small Item", "Transfer Hand-to-Hand", "Place in Container", "Stack Two Blocks", "Knock Down Stack", "Point at Object", "Clap Hands", "Wave Bye", "End Play"]
            case "balance_stand":
                return ["Stand with Support", "Lift One Foot", "Weight Shift Right", "Weight Shift Left", "Reach Up High", "Reach Down Low", "Turn Head Right", "Turn Head Left", "Brief No Hands", "Finish"]
            case "climb_explore":
                return ["Crawl to Step", "Climb Up One Step", "Sit on Step", "Climb Down (Assist)", "Climb Over Pillow", "Climb Into Box", "Climb Out of Box", "Rest", "Repeat", "End Explore"]
            case "push_pull":
                return ["Push Toy Forward", "Pull Toy Backward", "Push Standing", "Pull Standing", "Push While Walking", "Pull While Walking", "Push to Wall", "Pull Back", "Rest", "Finish"]
            case "coordination_play":
                return ["Roll Ball Forward", "Catch Ball", "Stack Blocks", "Knock Blocks", "Put In Container", "Take Out Container", "Turn Pages", "Press Buttons", "Clap & Dance", "End Play"]
            default:
                return Array(repeating: themeTitle, count: 10)
            }
        }
        
        if categoryId == "p_10_12" {
            switch themeSlug {
            case "stand_strong":
                return ["Stand Independently", "Hold 5 Seconds", "Reach Up", "Reach Down", "Turn Around", "Squat & Stand", "One Foot Lift", "Weight Shift", "Clap Standing", "Finish"]
            case "first_steps":
                return ["Stand Independently", "One Step Forward", "Two Steps Forward", "Walk to Parent", "Walk to Toy", "Turn While Walking", "Stop & Start", "Walk & Clap", "Short Walk", "End Walk"]
            case "cruise_confident":
                return ["Cruise Right", "Cruise Left", "Let Go Briefly", "Cruise Fast", "Cruise & Reach", "Turn Corner", "Cruise Backward", "Change Direction", "Rest", "Finish"]
            case "squat_stand":
                return ["Stand Up", "Squat Down", "Pick Up Toy", "Stand Up", "Squat Again", "Place Toy", "Stand Up", "Repeat Fast", "Rest", "End"]
            case "walk_assist":
                return ["Hold One Hand", "Walk Forward", "Walk Sideways", "Walk Backward", "Let Go Briefly", "Walk to Toy", "Walk & Stop", "Walk & Turn", "Rest", "Finish"]
            case "fine_motor":
                return ["Pincer Grasp", "Stack 3 Blocks", "Nest Cups", "Turn Pages", "Point & Poke", "Drop In Slot", "Scribble", "Clap Hands", "Wave", "End Play"]
            case "ball_play":
                return ["Roll Ball", "Catch Ball", "Throw Ball", "Kick Ball", "Chase Ball", "Roll to Target", "Throw in Basket", "Kick to Goal", "Rest", "Finish"]
            case "climb_stairs":
                return ["Crawl Up Step", "Stand on Step", "Step Up (Assist)", "Step Down (Assist)", "Climb Two Steps", "Sit on Step", "Stand Up", "Step Down", "Rest", "End"]
            case "push_walk":
                return ["Push Toy Standing", "Push & Walk", "Push Forward", "Push & Turn", "Push Fast", "Push Slow", "Push to Wall", "Push Back", "Rest", "Finish"]
            case "dance_move":
                return ["Stand & Bounce", "Sway Side-to-Side", "Clap to Music", "Stomp Feet", "Turn Around", "Arms Up", "Bend Knees", "Spin Slow", "Rest", "Finish"]
            default:
                return Array(repeating: themeTitle, count: 10)
            }
        }
        
        if categoryId == "p_12_18" {
            switch themeSlug {
            case "walk_confident":
                return ["Walk Forward", "Walk Fast", "Walk Slow", "Walk & Stop", "Walk & Turn", "Walk Backward", "Walk Sideways", "Walk in Circle", "Walk & Clap", "Finish"]
            case "run_explore":
                return ["Fast Walk", "Slow Run", "Run to Parent", "Run to Toy", "Run & Stop", "Change Direction", "Run Around Object", "Run & Laugh", "Rest", "End"]
            case "jump_practice":
                return ["Bounce on Spot", "Small Jump", "Jump Forward", "Jump on Mat", "Jump Off Step", "Jump & Land", "Jump & Clap", "Jump to Music", "Rest", "Finish"]
            case "kick_throw":
                return ["Kick Ball Forward", "Throw Ball", "Kick to Target", "Throw in Basket", "Kick & Chase", "Throw & Catch", "Kick Standing", "Throw Overhand", "Rest", "End Play"]
            case "climb_stairs_independent":
                return ["Walk Up Step", "Walk Down Step", "Climb Up Stairs", "Climb Down Stairs", "Step Over Object", "Climb on Couch", "Climb Down Couch", "Step Practice", "Rest", "Finish"]
            case "balance_beam":
                return ["Walk on Line", "Walk on Tape", "Walk on Curb", "Balance on One Foot", "Walk Heel-Toe", "Arms Out Balance", "Turn on Line", "Walk Backward", "Rest", "End"]
            case "push_pull_walk":
                return ["Push Toy Walking", "Pull Toy Walking", "Push Fast", "Pull Fast", "Push & Turn", "Pull & Turn", "Push Uphill", "Pull Backward", "Rest", "Finish"]
            case "dance_rhythm":
                return ["Dance to Music", "Stomp Feet", "Clap Hands", "Spin Around", "Jump to Beat", "Sway Side-to-Side", "Arms Up & Down", "March in Place", "Bow", "Finish"]
            case "obstacle_course":
                return ["Crawl Under Table", "Step Over Pillow", "Walk Around Cone", "Climb Over Box", "Walk on Tape", "Jump on Mat", "Push Toy", "Throw Ball", "Rest", "End Course"]
            case "fine_motor_advanced":
                return ["Stack 6 Blocks", "String Beads", "Turn Pages", "Scribble Circle", "Use Spoon", "Pour Water", "Zip Zipper", "Button Practice", "Clap Pattern", "End Play"]
            default:
                return Array(repeating: themeTitle, count: 10)
            }
        }
        
        return Array(repeating: themeTitle, count: 10)
    }
    
    static func themeTitleForSlug(categoryId: String, themeSlug: String) -> String {
        if categoryId == "p_0_2" {
            switch themeSlug {
            case "calm_connect": return "Calm & Connect"
            case "track_soothe": return "Track & Soothe"
            case "stretch": return "Gentle Stretches"
            case "arm_mobility": return "Arm Mobility"
            case "side_lying": return "Side-lying Support"
            case "massage": return "Gentle Massage"
            case "feeding_posture": return "Feeding Posture"
            case "sensory_calm": return "Sensory Calm"
            default: return themeSlug
            }
        }
        
        if categoryId == "p_2_4" {
            switch themeSlug {
            case "tummy": return "Tummy Time Starter"
            case "head_control": return "Head Control"
            case "reach_track": return "Reach & Track"
            case "sensory_play": return "Sensory Play"
            case "calm_reset": return "Calm Reset"
            case "gentle_mobility": return "Gentle Mobility"
            default: return themeSlug
            }
        }
        
        if categoryId == "p_4_6" {
            switch themeSlug {
            case "tummy_reach": return "Tummy Reach & Play"
            case "roll_to_tummy": return "Roll to Tummy"
            case "roll_to_back": return "Roll to Back"
            case "side_lying": return "Side-lying Play"
            case "sit_support": return "Supported Sitting"
            case "sit_balance": return "Sitting Balance"
            case "hands_grasp": return "Hands & Grasp"
            case "feet_play": return "Feet Discovery"
            case "pivot_play": return "Pivot & Turn"
            case "back_play": return "Back Play & Reach"
            default: return themeSlug
            }
        }
        
        if categoryId == "p_6_8" {
            switch themeSlug {
            case "sit_balance": return "Sitting Balance"
            case "sit_to_floor": return "Sit to Floor"
            case "floor_to_sit": return "Floor to Sit"
            case "all_fours_rock": return "All-Fours Rocking"
            case "hands_knees_setup": return "Hands & Knees Setup"
            case "belly_crawl": return "Belly Crawl"
            case "reach_pivot": return "Reach & Pivot"
            case "kneel_play": return "Kneel Play"
            case "hand_coordination": return "Hand Coordination"
            case "cause_effect_play": return "Cause & Effect"
            default: return themeSlug
            }
        }
        
        if categoryId == "p_8_10" {
            switch themeSlug {
            case "crawl_explore": return "Crawl & Explore"
            case "pull_to_stand": return "Pull to Stand"
            case "cruise_furniture": return "Cruise Furniture"
            case "squat_play": return "Squat Play"
            case "transition_practice": return "Transition Practice"
            case "hand_skills": return "Hand Skills"
            case "balance_stand": return "Balance Standing"
            case "climb_explore": return "Climb & Explore"
            case "push_pull": return "Push & Pull"
            case "coordination_play": return "Coordination Play"
            default: return themeSlug
            }
        }
        
        if categoryId == "p_10_12" {
            switch themeSlug {
            case "stand_strong": return "Stand Strong"
            case "first_steps": return "First Steps"
            case "cruise_confident": return "Confident Cruising"
            case "squat_stand": return "Squat & Stand"
            case "walk_assist": return "Assisted Walking"
            case "fine_motor": return "Fine Motor Skills"
            case "ball_play": return "Ball Play"
            case "climb_stairs": return "Climb Stairs"
            case "push_walk": return "Push & Walk"
            case "dance_move": return "Dance & Move"
            default: return themeSlug
            }
        }
        
        if categoryId == "p_12_18" {
            switch themeSlug {
            case "walk_confident": return "Confident Walking"
            case "run_explore": return "Run & Explore"
            case "jump_practice": return "Jump Practice"
            case "kick_throw": return "Kick & Throw"
            case "climb_stairs_independent": return "Independent Stairs"
            case "balance_beam": return "Balance Beam"
            case "push_pull_walk": return "Push & Pull Walking"
            case "dance_rhythm": return "Dance & Rhythm"
            case "obstacle_course": return "Obstacle Course"
            case "fine_motor_advanced": return "Advanced Fine Motor"
            default: return themeSlug
            }
        }
        
        return themeSlug
    }
    
    static func themeHintForSlug(categoryId: String, themeSlug: String) -> String {
        if categoryId == "p_0_2" {
            switch themeSlug {
            case "calm_connect": return "Parent: Gentle holds and slow movements support bonding and regulation."
            case "track_soothe": return "Parent: Use slow-moving toys or your face for tracking practice."
            case "stretch": return "Parent: Gentle stretches in a comfortable range only—no forcing."
            case "arm_mobility": return "Parent: Support shoulders and move arms slowly through comfortable ranges."
            case "side_lying": return "Parent: Side-lying with towel support helps midline hands and head control."
            case "massage": return "Parent: Gentle massage with calm voice. Stop if baby shows discomfort."
            case "feeding_posture": return "Parent: Check chin off chest, midline alignment, and switch sides regularly."
            case "sensory_calm": return "Parent: One sensory item at a time. Stop if overstimulated."
            default: return "Parent tip: follow your child's cues and keep it playful."
            }
        }
        
        if categoryId == "p_2_4" {
            switch themeSlug {
            case "tummy": return "Parent: Short tummy sets with breaks. Use toys for motivation."
            case "head_control": return "Parent: Support at chest/trunk and practice slow head turns."
            case "reach_track": return "Parent: Place toys within reach and track slowly side-to-side."
            case "sensory_play": return "Parent: One texture or toy at a time. Stop if overstimulated."
            case "calm_reset": return "Parent: Slow rocks, quiet voice, and dim lights for regulation."
            case "gentle_mobility": return "Parent: Mix tummy, side-lying, and back play with frequent breaks."
            default: return "Parent tip: follow your child's cues and keep it playful."
            }
        }
        
        if categoryId == "p_4_6" {
            switch themeSlug {
            case "tummy_reach": return "Parent: Short tummy sets with reaching. Support elbows under shoulders and keep it calm."
            case "roll_to_tummy": return "Parent: Guide the roll with a toy and gentle support at shoulder/hip. Avoid pulling by arms."
            case "roll_to_back": return "Parent: From tummy, guide hips and pause on the side before rolling to back. Keep it slow."
            case "side_lying": return "Parent: Supported side-lying helps midline hands and rolling setup. Always supervise."
            case "sit_support": return "Parent: Support at hips/trunk for short sitting sets. Reset often—avoid pushing through fatigue."
            case "sit_balance": return "Parent: Tiny reaches to the side build balance. Keep baby safe and supervised."
            case "hands_grasp": return "Parent: Offer safe, easy-to-grab toys to practice grasp and transfers. Keep it brief."
            case "feet_play": return "Parent: Encourage gentle feet discovery (hands-to-feet, toe wiggles). Comfort range only."
            case "pivot_play": return "Parent: Place toys to the side on tummy time to encourage tiny pivots. Alternate sides."
            case "back_play": return "Parent: Back play is a great rest between tummy sets—use slow toy movement and midline hands."
            default: return "Parent tip: follow your child's cues and keep it playful."
            }
        }
        
        if categoryId == "p_6_8" {
            switch themeSlug {
            case "sit_balance": return "Parent: Sitting balance with tiny reaches. Support at hips and keep sets short."
            case "sit_to_floor": return "Parent: Controlled lowering from sit to floor. Guide hands forward and keep it slow."
            case "floor_to_sit": return "Parent: From tummy/side, guide baby to sitting. Support at hips and celebrate effort."
            case "all_fours_rock": return "Parent: Rocking on hands-and-knees builds crawl readiness. Keep it brief and playful."
            case "hands_knees_setup": return "Parent: Short holds on hands-and-knees. Support at hips if needed and keep it calm."
            case "belly_crawl": return "Parent: Belly crawl with toy motivation. Celebrate any forward movement and keep it fun."
            case "reach_pivot": return "Parent: Reaching and pivoting on tummy. Place toys to the side to encourage turning."
            case "kneel_play": return "Parent: Supported tall kneel at a stable surface builds hips/trunk. Keep it short and supervised."
            case "hand_coordination": return "Parent: Practice transfers and simple container play with safe, large objects."
            case "cause_effect_play": return "Parent: Simple cause-and-effect toys build focus. Demonstrate once, then let baby try."
            default: return "Parent tip: follow your child's cues and keep it playful."
            }
        }
        
        if categoryId == "p_8_10" {
            switch themeSlug {
            case "crawl_explore": return "Parent: Encourage crawling exploration with toys and safe obstacles. Supervise closely."
            case "pull_to_stand": return "Parent: Support at trunk as baby pulls to stand. Use stable furniture and celebrate effort."
            case "cruise_furniture": return "Parent: Baby-proof furniture edges. Stay close as baby cruises and practices side-stepping."
            case "squat_play": return "Parent: Squatting builds leg strength. Place toys low to encourage squatting and standing."
            case "transition_practice": return "Parent: Practice moving between positions. Support as needed and keep it playful."
            case "hand_skills": return "Parent: Offer small safe objects for pincer grasp. Supervise closely to prevent choking."
            case "balance_stand": return "Parent: Stand close for safety. Brief balance challenges build confidence and strength."
            case "climb_explore": return "Parent: Supervise all climbing. Use soft surfaces and teach safe climbing down."
            case "push_pull": return "Parent: Push and pull toys build strength and coordination. Clear space for safe movement."
            case "coordination_play": return "Parent: Simple coordination activities build skills. Keep it fun and celebrate attempts."
            default: return "Parent tip: follow your child's cues and keep it playful."
            }
        }
        
        if categoryId == "p_10_12" {
            switch themeSlug {
            case "stand_strong": return "Parent: Independent standing builds confidence. Stay close and celebrate balance achievements."
            case "first_steps": return "Parent: First steps are exciting! Stay close, encourage, and celebrate every attempt."
            case "cruise_confident": return "Parent: Confident cruising leads to walking. Provide stable furniture and stay nearby."
            case "squat_stand": return "Parent: Squatting and standing builds leg strength. Make it a game with toys."
            case "walk_assist": return "Parent: Hold one hand for support. Gradually reduce assistance as confidence grows."
            case "fine_motor": return "Parent: Fine motor skills develop through play. Offer blocks, cups, and safe small objects."
            case "ball_play": return "Parent: Ball play builds coordination. Use soft balls and keep it fun and simple."
            case "climb_stairs": return "Parent: Always supervise stairs. Teach safe climbing and use gates when unsupervised."
            case "push_walk": return "Parent: Push toys support early walking. Ensure toys are stable and the path is clear."
            case "dance_move": return "Parent: Dancing builds rhythm and balance. Play music and move together."
            default: return "Parent tip: follow your child's cues and keep it playful."
            }
        }
        
        if categoryId == "p_12_18" {
            switch themeSlug {
            case "walk_confident": return "Parent: Confident walking opens new exploration. Provide safe spaces and supervise closely."
            case "run_explore": return "Parent: Early running is unsteady. Clear obstacles and stay close for safety."
            case "jump_practice": return "Parent: Jumping develops gradually. Use soft surfaces and celebrate small jumps."
            case "kick_throw": return "Parent: Kicking and throwing build coordination. Use soft balls in safe spaces."
            case "climb_stairs_independent": return "Parent: Supervise all stair use. Teach safe techniques and use gates when needed."
            case "balance_beam": return "Parent: Balance activities build confidence. Start low and stay close for safety."
            case "push_pull_walk": return "Parent: Push and pull toys while walking builds strength. Clear the path of obstacles."
            case "dance_rhythm": return "Parent: Dancing builds coordination and joy. Move together to music and have fun."
            case "obstacle_course": return "Parent: Simple obstacle courses build multiple skills. Keep it safe and age-appropriate."
            case "fine_motor_advanced": return "Parent: Advanced fine motor skills take practice. Offer varied activities and celebrate progress."
            default: return "Parent tip: follow your child's cues and keep it playful."
            }
        }
        
        return "Parent tip: follow your child's cues and keep it playful."
    }
    
    static func exerciseStepsForTheme(categoryId: String, themeSlug: String) -> [String] {
        if categoryId == "p_0_2" {
            return [
                "Setup: calm environment, baby comfortable",
                "Begin: slow, gentle movement",
                "Observe: watch baby's cues",
                "Pause: reset if needed",
                "Continue: maintain calm pace",
                "Support: use hands for stability",
                "Encourage: soft voice cues",
                "Adjust: respond to baby's signals",
                "Complete: finish gently",
                "Rest: allow recovery time"
            ]
        }
        
        if categoryId == "p_2_4" {
            return [
                "Setup: position baby safely",
                "Begin: introduce movement slowly",
                "Motivate: use toy or voice",
                "Support: provide trunk/head support",
                "Pause: short breaks as needed",
                "Encourage: celebrate small wins",
                "Adjust: modify based on response",
                "Continue: keep sets brief",
                "Complete: end on positive note",
                "Rest: allow full recovery"
            ]
        }
        
        if categoryId == "p_4_6" {
            return [
                "Setup: safe surface, toys ready",
                "Begin: demonstrate movement",
                "Motivate: place toy strategically",
                "Support: assist at hips/trunk",
                "Encourage: use voice and praise",
                "Pause: reset between attempts",
                "Progress: reduce support gradually",
                "Observe: watch for fatigue",
                "Complete: finish with success",
                "Rest: allow adequate recovery"
            ]
        }
        
        if categoryId == "p_6_8" {
            return [
                "Setup: clear space, safe surface",
                "Begin: demonstrate the movement",
                "Motivate: use engaging toys",
                "Support: minimal assistance",
                "Encourage: praise effort and progress",
                "Challenge: increase difficulty slightly",
                "Pause: rest between repetitions",
                "Observe: monitor form and fatigue",
                "Complete: end with achievement",
                "Rest: allow full recovery"
            ]
        }
        
        if categoryId == "p_8_10" {
            return [
                "Setup: safe space, remove hazards",
                "Begin: demonstrate activity",
                "Motivate: use toys and encouragement",
                "Support: stay close for safety",
                "Encourage: celebrate all attempts",
                "Challenge: add slight difficulty",
                "Pause: rest when needed",
                "Observe: watch for fatigue",
                "Complete: end positively",
                "Rest: allow recovery"
            ]
        }
        
        if categoryId == "p_10_12" {
            return [
                "Setup: clear safe area",
                "Begin: show the activity",
                "Motivate: make it fun",
                "Support: provide minimal help",
                "Encourage: praise efforts",
                "Challenge: increase complexity",
                "Pause: take breaks",
                "Observe: monitor safety",
                "Complete: celebrate success",
                "Rest: allow rest time"
            ]
        }
        
        if categoryId == "p_12_18" {
            return [
                "Setup: prepare safe space",
                "Begin: demonstrate clearly",
                "Motivate: keep it playful",
                "Support: supervise closely",
                "Encourage: positive reinforcement",
                "Challenge: add variations",
                "Pause: rest as needed",
                "Observe: ensure safety",
                "Complete: finish with praise",
                "Rest: recovery time"
            ]
        }
        
        return [
            "Setup: prepare environment",
            "Begin: start movement",
            "Support: provide assistance",
            "Encourage: use positive cues",
            "Pause: rest as needed",
            "Progress: advance gradually",
            "Observe: watch baby's response",
            "Adjust: modify as needed",
            "Complete: finish activity",
            "Rest: allow recovery"
        ]
    }
    
    static func getAllCategories() -> [BabyCategory] {
        return [
            BabyCategory(categoryId: "p_0_2", title: "0-2 Months", ageRangeMin: 0, ageRangeMax: 2, icon: "🍼", color: "pastelPink"),
            BabyCategory(categoryId: "p_2_4", title: "2-4 Months", ageRangeMin: 2, ageRangeMax: 4, icon: "👶", color: "pastelBlue"),
            BabyCategory(categoryId: "p_4_6", title: "4-6 Months", ageRangeMin: 4, ageRangeMax: 6, icon: "🎯", color: "pastelGreen"),
            BabyCategory(categoryId: "p_6_8", title: "6-8 Months", ageRangeMin: 6, ageRangeMax: 8, icon: "🧸", color: "pastelYellow"),
            BabyCategory(categoryId: "p_8_10", title: "8-10 Months", ageRangeMin: 8, ageRangeMax: 10, icon: "🎨", color: "pastelPurple"),
            BabyCategory(categoryId: "p_10_12", title: "10-12 Months", ageRangeMin: 10, ageRangeMax: 12, icon: "🚼", color: "pastelOrange"),
            BabyCategory(categoryId: "p_12_18", title: "12-18 Months", ageRangeMin: 12, ageRangeMax: 18, icon: "🎪", color: "pastelMint")
        ]
    }
    
    static func getThemesForCategory(categoryId: String) -> [(slug: String, title: String)] {
        switch categoryId {
        case "p_0_2":
            return [
                ("calm_connect", "Calm & Connect"),
                ("track_soothe", "Track & Soothe"),
                ("stretch", "Gentle Stretches"),
                ("arm_mobility", "Arm Mobility"),
                ("side_lying", "Side-lying Support"),
                ("massage", "Gentle Massage"),
                ("feeding_posture", "Feeding Posture"),
                ("sensory_calm", "Sensory Calm")
            ]
        case "p_2_4":
            return [
                ("tummy", "Tummy Time Starter"),
                ("head_control", "Head Control"),
                ("reach_track", "Reach & Track"),
                ("sensory_play", "Sensory Play"),
                ("calm_reset", "Calm Reset"),
                ("gentle_mobility", "Gentle Mobility")
            ]
        case "p_4_6":
            return [
                ("tummy_reach", "Tummy Reach & Play"),
                ("roll_to_tummy", "Roll to Tummy"),
                ("roll_to_back", "Roll to Back"),
                ("side_lying", "Side-lying Play"),
                ("sit_support", "Supported Sitting"),
                ("sit_balance", "Sitting Balance"),
                ("hands_grasp", "Hands & Grasp"),
                ("feet_play", "Feet Discovery"),
                ("pivot_play", "Pivot & Turn"),
                ("back_play", "Back Play & Reach")
            ]
        case "p_6_8":
            return [
                ("sit_balance", "Sitting Balance"),
                ("sit_to_floor", "Sit to Floor"),
                ("floor_to_sit", "Floor to Sit"),
                ("all_fours_rock", "All-Fours Rocking"),
                ("hands_knees_setup", "Hands & Knees Setup"),
                ("belly_crawl", "Belly Crawl"),
                ("reach_pivot", "Reach & Pivot"),
                ("kneel_play", "Kneel Play"),
                ("hand_coordination", "Hand Coordination"),
                ("cause_effect_play", "Cause & Effect")
            ]
        case "p_8_10":
            return [
                ("crawl_explore", "Crawl & Explore"),
                ("pull_to_stand", "Pull to Stand"),
                ("cruise_furniture", "Cruise Furniture"),
                ("squat_play", "Squat Play"),
                ("transition_practice", "Transition Practice"),
                ("hand_skills", "Hand Skills"),
                ("balance_stand", "Balance Standing"),
                ("climb_explore", "Climb & Explore"),
                ("push_pull", "Push & Pull"),
                ("coordination_play", "Coordination Play")
            ]
        case "p_10_12":
            return [
                ("stand_strong", "Stand Strong"),
                ("first_steps", "First Steps"),
                ("cruise_confident", "Confident Cruising"),
                ("squat_stand", "Squat & Stand"),
                ("walk_assist", "Assisted Walking"),
                ("fine_motor", "Fine Motor Skills"),
                ("ball_play", "Ball Play"),
                ("climb_stairs", "Climb Stairs"),
                ("push_walk", "Push & Walk"),
                ("dance_move", "Dance & Move")
            ]
        case "p_12_18":
            return [
                ("walk_confident", "Confident Walking"),
                ("run_explore", "Run & Explore"),
                ("jump_practice", "Jump Practice"),
                ("kick_throw", "Kick & Throw"),
                ("climb_stairs_independent", "Independent Stairs"),
                ("balance_beam", "Balance Beam"),
                ("push_pull_walk", "Push & Pull Walking"),
                ("dance_rhythm", "Dance & Rhythm"),
                ("obstacle_course", "Obstacle Course"),
                ("fine_motor_advanced", "Advanced Fine Motor")
            ]
        default:
            return []
        }
    }
}
