namespace STEMMA.Domain.Consultas.Entities;

public class Consulta
{
    public Guid Id { get; private set; }

    public Guid PetId { get; private set; }

    public DateTime DataConsulta { get; private set; }

    public string Veterinario { get; private set; }

    public bool Encerrada { get; private set; }

    protected Consulta() { }

    public Consulta(
        Guid petId,
        DateTime dataConsulta,
        string veterinario)
    {
        Validar(dataConsulta, veterinario);

        Id = Guid.NewGuid();
        PetId = petId;
        DataConsulta = dataConsulta;
        Veterinario = veterinario;
        Encerrada = false;
    }

    public void EncerrarConsulta()
    {
        if (Encerrada)
            throw new Exception("A consulta já foi encerrada.");

        Encerrada = true;
    }

    private void Validar(
        DateTime dataConsulta,
        string veterinario)
    {
        if (dataConsulta < DateTime.UtcNow)
            throw new Exception("Não é permitido agendar consultas no passado.");

        if (string.IsNullOrWhiteSpace(veterinario))
            throw new Exception("Veterinário obrigatório.");
    }
}