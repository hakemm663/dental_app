import java.io.File

allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

val rootBuildDir = File(rootProject.projectDir, "../../build")
rootProject.layout.buildDirectory.set(rootBuildDir)

subprojects {
    val subprojectBuildDir = File(rootBuildDir, project.name)
    
    val projectPath = project.projectDir.absolutePath
    val buildPath = subprojectBuildDir.absolutePath
    
    // Check if both are on the same drive (Windows) or same root.
    // This avoids "different roots" errors when plugins are in C:\ (Pub Cache) 
    // and the project is on another drive (e.g., E:\).
    val sameDrive = if (projectPath.length >= 2 && projectPath[1] == ':' && 
                        buildPath.length >= 2 && buildPath[1] == ':') {
        projectPath.substring(0, 1).equals(buildPath.substring(0, 1), ignoreCase = true)
    } else {
        true 
    }

    if (sameDrive) {
        project.layout.buildDirectory.set(subprojectBuildDir)
    }
}

subprojects {
    project.evaluationDependsOn(":app")
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
