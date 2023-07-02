// An optional sbt file to replace Scala.js 1.0 with 0.6
dependencyOverrides += Defaults.sbtPluginExtra(
  "org.scala-js" % "sbt-scalajs" % "1.13.2",
  sbtBinaryVersion.value,
  scalaBinaryVersion.value,
)

Compile / sourceGenerators += Def.task {
  val file = (Compile / sourceManaged).value / "SkipPublishForNonScalaJSProjects.scala"
  IO.write(file, """
    import scalajscrossproject.ScalaJSCrossPlugin.autoImport._
    import sbtcrossproject.CrossPlugin.autoImport._
    import sbt._, Keys._
    object SkipPublishForNonScalaJSProjects extends AutoPlugin {
      override def trigger = allRequirements
      override def projectSettings = Seq(
        publish / skip := crossProjectPlatform.value != JSPlatform
      )
    }
  """)
  Seq(file)
}.taskValue
